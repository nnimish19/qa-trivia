class Question < ApplicationRecord
  belongs_to :user
  has_many :tags
  has_many :responses
  
end
