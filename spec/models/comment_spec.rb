require 'rails_helper'

RSpec.describe Comment, type: :model do
  # Validation tests using shoulda-matchers
  it { should validate_presence_of(:text) }

  # Association tests using shoulda-matchers
  it { should belong_to(:issue) }

  describe "with valid attributes" do
    it "should be valid" do
      comment = build(:comment)
      expect(comment).to be_valid
    end
  end
end