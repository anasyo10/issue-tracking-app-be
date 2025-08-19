class Comment < ApplicationRecord
  belongs_to :issue
  
  validates :text, presence: true
end
