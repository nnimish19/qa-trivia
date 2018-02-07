class Question < ApplicationRecord
  validates :statement, presence: true, length: { minimum: 5 }
  validates :answer, presence: true

  belongs_to :user
  has_many :responses
  has_many :question_tags
  has_many :tags, through: :question_tags

  
end
