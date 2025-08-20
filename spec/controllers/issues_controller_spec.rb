require 'rails_helper'

RSpec.describe IssuesController, type: :controller do
  before do
    @project = Project.create!(name: "Test Project")
    @issue = Issue.create!(
      title: "Test Issue",
      description: "Test Description",
      assigned_to: "Test User",
      status: "to_do",
      project: @project
    )
  end

  describe "GET #index" do
    it "returns success response" do
      get :index, params: { project_id: @project.id }, as: :json
      expect(response).to have_http_status(:success)

      response_data = JSON.parse(response.body)
      expect(response_data.length).to eq(1)
      expect(response_data.first["title"]).to eq(@issue.title)
      expect(response_data.first["project"]).not_to be_nil
      expect(response_data.first["comments"]).not_to be_nil
    end

    it "returns 404 for non-existent project" do
      get :index, params: { project_id: 9999 }, as: :json
      expect(response).to have_http_status(:not_found)
    end

    it "only shows issues for specific project" do
      other_project = Project.create!(name: "Other Project")
      other_issue = Issue.create!(
        title: "Other Issue",
        description: "Other Description",
        assigned_to: "Other User",
        status: "to_do",
        project: other_project
      )

      get :index, params: { project_id: @project.id }, as: :json
      expect(response).to have_http_status(:success)

      response_data = JSON.parse(response.body)
      expect(response_data.length).to eq(1)
      expect(response_data.first["title"]).to eq(@issue.title)
      expect(response_data.first["title"]).not_to eq(other_issue.title)
    end
  end

  describe "GET #show" do
    it "returns success response" do
      get :show, params: { project_id: @project.id, id: @issue.id }, as: :json
      expect(response).to have_http_status(:success)

      response_data = JSON.parse(response.body)
      expect(response_data["title"]).to eq(@issue.title)
      expect(response_data["project"]).not_to be_nil
      expect(response_data["comments"]).not_to be_nil
    end

    it "returns 404 for non-existent issue" do
      get :show, params: { project_id: @project.id, id: 9999 }, as: :json
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST #create" do
    it "creates issue with valid params" do
      expect {
        post :create, params: {
          project_id: @project.id,
          issue: {
            title: "New Issue",
            description: "New Description",
            assigned_to: "New User",
            status: "to_do"
          }
        }, as: :json
      }.to change(Issue, :count).by(1)

      expect(response).to have_http_status(:created)
      response_data = JSON.parse(response.body)
      expect(response_data["title"]).to eq("New Issue")
      expect(response_data["description"]).to eq("New Description")
      expect(response_data["assigned_to"]).to eq("New User")
      expect(response_data["status"]).to eq("to_do")
      expect(response_data["project"]["id"]).to eq(@project.id)
    end

    it "does not create issue with invalid params" do
      expect {
        post :create, params: {
          project_id: @project.id,
          issue: {
            title: "",
            description: "",
            assigned_to: ""
          }
        }, as: :json
      }.not_to change(Issue, :count)

      expect(response).to have_http_status(:unprocessable_content)
      response_data = JSON.parse(response.body)
      expect(response_data["errors"]["title"]).to include("can't be blank")
      expect(response_data["errors"]["description"]).to include("can't be blank")
      expect(response_data["errors"]["assigned_to"]).to include("can't be blank")
    end
  end

  describe "PATCH #update" do
    it "updates issue with valid params" do
      patch :update, params: {
        project_id: @project.id,
        id: @issue.id,
        issue: {
          title: "Updated Issue",
          status: "active"
        }
      }, as: :json
      expect(response).to have_http_status(:success)

      response_data = JSON.parse(response.body)
      expect(response_data["title"]).to eq("Updated Issue")
      expect(response_data["status"]).to eq("active")

      @issue.reload
      expect(@issue.title).to eq("Updated Issue")
      expect(@issue.status).to eq("active")
    end

    it "does not update issue with invalid params" do
      patch :update, params: {
        project_id: @project.id,
        id: @issue.id,
        issue: {
          title: "",
          description: ""
        }
      }, as: :json
      expect(response).to have_http_status(:unprocessable_content)

      response_data = JSON.parse(response.body)
      expect(response_data["errors"]["title"]).to include("can't be blank")
      expect(response_data["errors"]["description"]).to include("can't be blank")
    end
  end

  describe "DELETE #destroy" do
    it "destroys issue" do
      expect {
        delete :destroy, params: { project_id: @project.id, id: @issue.id }, as: :json
      }.to change(Issue, :count).by(-1)

      expect(response).to have_http_status(:success)
      response_data = JSON.parse(response.body)
      expect(response_data["message"]).to eq("Issue deleted successfully")
    end
  end
end
