class Issue < ApplicationRecord
  belongs_to :project
  has_many :comments, dependent: :destroy
  
  enum :status, { to_do: 0, active: 1, on_hold: 2, resolved: 3 }
  
  validates :title, presence: true, length: { maximum: 255 }
  validates :description, presence: true
  validates :assigned_to, presence: true, length: { maximum: 255 }
  validates :status, presence: true
end
