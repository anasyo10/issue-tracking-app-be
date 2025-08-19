require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  before do
    @project = Project.create!(name: "Test Project")
  end

  describe "GET #index" do
    it "returns success response" do
      get :index, as: :json
      expect(response).to have_http_status(:success)
      
      response_data = JSON.parse(response.body)
      expect(response_data.length).to eq(1)
      expect(response_data.first["name"]).to eq(@project.name)
    end
  end

  describe "GET #show" do
    it "returns success response" do
      get :show, params: { id: @project.id }, as: :json
      expect(response).to have_http_status(:success)
      
      response_data = JSON.parse(response.body)
      expect(response_data["name"]).to eq(@project.name)
    end

    it "returns 404 for non-existent project" do
      get :show, params: { id: 9999 }, as: :json
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST #create" do
    it "creates project with valid params" do
      expect {
        post :create, params: { project: { name: "New Project" } }, as: :json
      }.to change(Project, :count).by(1)

      expect(response).to have_http_status(:created)
      response_data = JSON.parse(response.body)
      expect(response_data["name"]).to eq("New Project")
    end

    it "does not create project with invalid params" do
      expect {
        post :create, params: { project: { name: "" } }, as: :json
      }.not_to change(Project, :count)

      expect(response).to have_http_status(:unprocessable_content)
      response_data = JSON.parse(response.body)
      expect(response_data["errors"]["name"]).to include("can't be blank")
    end
  end

  describe "PATCH #update" do
    it "updates project with valid params" do
      patch :update, params: { id: @project.id, project: { name: "Updated Project" } }, as: :json
      expect(response).to have_http_status(:success)
      
      response_data = JSON.parse(response.body)
      expect(response_data["name"]).to eq("Updated Project")
      
      @project.reload
      expect(@project.name).to eq("Updated Project")
    end

    it "does not update project with invalid params" do
      patch :update, params: { id: @project.id, project: { name: "" } }, as: :json
      expect(response).to have_http_status(:unprocessable_content)
      
      response_data = JSON.parse(response.body)
      expect(response_data["errors"]["name"]).to include("can't be blank")
    end
  end

  describe "DELETE #destroy" do
    it "destroys project" do
      expect {
        delete :destroy, params: { id: @project.id }, as: :json
      }.to change(Project, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end