class Gram < ActiveRecord::Base
  validates :message, presence: true

  belongs_to :user, inverse_of: :grams
end