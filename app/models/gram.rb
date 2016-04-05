class Gram < ActiveRecord::Base
  belongs_to :user, inverse_of: :grams
  has_many :comments, inverse_of: :gram
  mount_uploader :image, ImageUploader

  validates :message, presence: true
  validates :image, presence: true
end