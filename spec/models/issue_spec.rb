require 'rails_helper'

RSpec.describe Issue, type: :model do
  # Validation tests using shoulda-matchers
  it { should validate_presence_of(:title) }
  it { should validate_length_of(:title).is_at_most(255) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:assigned_to) }
  it { should validate_length_of(:assigned_to).is_at_most(255) }
  it { should validate_presence_of(:status) }

  # Association tests using shoulda-matchers
  it { should belong_to(:project) }
  it { should have_many(:comments).dependent(:destroy) }

  # Enum tests
  it { should define_enum_for(:status).with_values(to_do: 0, active: 1, on_hold: 2, resolved: 3) }

  describe "with valid attributes" do
    it "should be valid" do
      issue = build(:issue)
      expect(issue).to be_valid
    end
  end

  describe "status enum values" do
    let(:issue) { create(:issue) }

    it "should handle all status values correctly" do
      issue.update!(status: "to_do")
      expect(issue.status_before_type_cast).to eq(0)

      issue.update!(status: "active")
      expect(issue.status_before_type_cast).to eq(1)

      issue.update!(status: "on_hold")
      expect(issue.status_before_type_cast).to eq(2)

      issue.update!(status: "resolved")
      expect(issue.status_before_type_cast).to eq(3)
    end
  end

  describe "dependent destroy" do
    it "should destroy associated comments when issue is destroyed" do
      issue = create(:issue)
      create_list(:comment, 2, issue: issue)
      
      expect { issue.destroy }.to change(Comment, :count).by(-2)
    end
  end
end