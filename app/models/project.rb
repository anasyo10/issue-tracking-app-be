class Project < ApplicationRecord
  has_many :issues, dependent: :destroy
  has_many :comments, through: :issues

  validates :name, presence: true
end
