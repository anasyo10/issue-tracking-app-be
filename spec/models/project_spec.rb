require 'rails_helper'

RSpec.describe Project, type: :model do
  # Validation tests using shoulda-matchers
  it { should validate_presence_of(:name) }

  # Association tests using shoulda-matchers
  it { should have_many(:issues).dependent(:destroy) }

  describe "with valid attributes" do
    it "should be valid" do
      project = build(:project)
      expect(project).to be_valid
    end
  end

  describe "dependent destroy" do
    it "should destroy associated issues when project is destroyed" do
      project = create(:project)
      create_list(:issue, 3, project: project)

      expect { project.destroy }.to change(Issue, :count).by(-3)
    end
  end
end
