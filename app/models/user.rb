class User < ActiveRecord::Base
  # Include default devise modules. Others available are: :confirmable, :lockable, and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :timeoutable

  has_many :grams, inverse_of: :user
end