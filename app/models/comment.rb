class Comment < ActiveRecord::Base
  belongs_to :gram, inverse_of: :comments
  belongs_to :user, inverse_of: :comments

  validates :message, presence: true
end