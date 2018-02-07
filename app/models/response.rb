class Response < ApplicationRecord
  validates :statement, presence: true
  belongs_to :user
  belongs_to :question
end
