require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  before do
    @project = Project.create!(name: "Test Project")
    @issue = Issue.create!(
      title: "Test Issue",
      description: "Test Description",
      assigned_to: "Test User",
      status: "to_do",
      project: @project
    )
    @comment = Comment.create!(text: "Test comment", issue: @issue)
  end

  describe "GET #index" do
    it "returns success response" do
      get :index, params: { issue_id: @issue.id }, as: :json
      expect(response).to have_http_status(:success)

      response_data = JSON.parse(response.body)
      expect(response_data.length).to eq(1)
      expect(response_data.first["text"]).to eq(@comment.text)
      expect(response_data.first["issue"]).not_to be_nil
    end

    it "returns 404 for non-existent issue" do
      get :index, params: { issue_id: 9999 }, as: :json
      expect(response).to have_http_status(:not_found)
    end

    it "only shows comments for specific issue" do
      other_issue = Issue.create!(
        title: "Other Issue",
        description: "Other Description",
        assigned_to: "Other User",
        status: "to_do",
        project: @project
      )
      other_comment = Comment.create!(text: "Other comment", issue: other_issue)

      get :index, params: { issue_id: @issue.id }, as: :json
      expect(response).to have_http_status(:success)

      response_data = JSON.parse(response.body)
      expect(response_data.length).to eq(1)
      expect(response_data.first["text"]).to eq(@comment.text)
      expect(response_data.first["text"]).not_to eq(other_comment.text)
    end
  end

  describe "GET #show" do
    it "returns success response" do
      get :show, params: { issue_id: @issue.id, id: @comment.id }, as: :json
      expect(response).to have_http_status(:success)

      response_data = JSON.parse(response.body)
      expect(response_data["text"]).to eq(@comment.text)
      expect(response_data["issue"]).not_to be_nil
    end

    it "returns 404 for non-existent comment" do
      get :show, params: { issue_id: @issue.id, id: 9999 }, as: :json
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST #create" do
    it "creates comment with valid params" do
      expect {
        post :create, params: {
          issue_id: @issue.id,
          comment: {
            text: "New comment"
          }
        }, as: :json
      }.to change(Comment, :count).by(1)

      expect(response).to have_http_status(:created)
      response_data = JSON.parse(response.body)
      expect(response_data["text"]).to eq("New comment")
      expect(response_data["issue"]["id"]).to eq(@issue.id)
    end

    it "does not create comment with invalid params" do
      expect {
        post :create, params: {
          issue_id: @issue.id,
          comment: {
            text: ""
          }
        }, as: :json
      }.not_to change(Comment, :count)

      expect(response).to have_http_status(:unprocessable_content)
      response_data = JSON.parse(response.body)
      expect(response_data["errors"]["text"]).to include("can't be blank")
    end
  end

  describe "PATCH #update" do
    it "updates comment with valid params" do
      patch :update, params: {
        issue_id: @issue.id,
        id: @comment.id,
        comment: {
          text: "Updated comment"
        }
      }, as: :json
      expect(response).to have_http_status(:success)

      response_data = JSON.parse(response.body)
      expect(response_data["text"]).to eq("Updated comment")

      @comment.reload
      expect(@comment.text).to eq("Updated comment")
    end

    it "does not update comment with invalid params" do
      patch :update, params: {
        issue_id: @issue.id,
        id: @comment.id,
        comment: {
          text: ""
        }
      }, as: :json
      expect(response).to have_http_status(:unprocessable_content)

      response_data = JSON.parse(response.body)
      expect(response_data["errors"]["text"]).to include("can't be blank")
    end
  end

  describe "DELETE #destroy" do
    it "destroys comment" do
      expect {
        delete :destroy, params: { issue_id: @issue.id, id: @comment.id }, as: :json
      }.to change(Comment, :count).by(-1)

      expect(response).to have_http_status(:success)
      response_data = JSON.parse(response.body)
      expect(response_data["message"]).to eq("Comment deleted successfully")
    end
  end
end
