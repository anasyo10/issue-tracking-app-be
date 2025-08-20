class CommentsController < ApplicationController
  before_action :set_issue
  before_action :set_comment, only: [ :show, :update, :destroy ]

  def index
    @comments = @issue.comments
    render json: @comments, include: [ :issue ]
  end

  def show
    render json: @comment, include: [ :issue ]
  end

  def create
    @comment = @issue.comments.build(comment_params)

    if @comment.save
      render json: @comment, status: :created, include: [ :issue ]
    else
      render json: { errors: @comment.errors }, status: :unprocessable_content
    end
  end

  def update
    if @comment.update(comment_params)
      render json: @comment, include: [ :issue ]
    else
      render json: { errors: @comment.errors }, status: :unprocessable_content
    end
  end

  def destroy
    @comment.destroy
    render json: { message: "Comment deleted successfully" }, status: :ok
  end

  private

  def set_issue
    @issue = Issue.find(params[:issue_id])
  rescue ActiveRecord::RecordNotFound
    head :not_found
  end

  def set_comment
    @comment = @issue.comments.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    head :not_found
  end

  def comment_params
    params.require(:comment).permit(:text)
  end
end
