class IssuesController < ApplicationController
  before_action :set_project
  before_action :set_issue, only: [ :show, :update, :destroy ]

  def index
    @issues = @project.issues.includes(:comments)
    render json: @issues, include: [ :project, :comments ]
  end

  def show
    render json: @issue, include: [ :project, :comments ]
  end

  def create
    @issue = @project.issues.build(issue_params)

    if @issue.save
      render json: @issue, status: :created, include: [ :project ]
    else
      render json: { errors: @issue.errors }, status: :unprocessable_content
    end
  end

  def update
    if @issue.update(issue_params)
      render json: @issue, include: [ :project ]
    else
      render json: { errors: @issue.errors }, status: :unprocessable_content
    end
  end

  def destroy
    @issue.destroy
    render json: { message: "Issue deleted successfully" }, status: :ok
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  rescue ActiveRecord::RecordNotFound
    head :not_found
  end

  def set_issue
    @issue = @project.issues.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    head :not_found
  end

  def issue_params
    params.require(:issue).permit(:title, :description, :assigned_to, :status)
  end
end
