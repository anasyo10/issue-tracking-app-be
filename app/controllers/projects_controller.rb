class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :update, :destroy]
  
  def index
    @projects = Project.all
    render json: @projects
  end
  
  def show
    render json: @project
  end
  
  def create
    @project = Project.new(project_params)
    
    if @project.save
      render json: @project, status: :created
    else
      render json: { errors: @project.errors }, status: :unprocessable_content
    end
  end
  
  def update
    if @project.update(project_params)
      render json: @project
    else
      render json: { errors: @project.errors }, status: :unprocessable_content
    end
  end
  
  def destroy
    @project.destroy
    render json: { message: "Project deleted successfully" }
  end
  
  private
  
  def set_project
    @project = Project.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    head :not_found
  end
  
  def project_params
    params.require(:project).permit(:name)
  end
end
