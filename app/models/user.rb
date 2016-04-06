class User < ActiveRecord::Base
  # Include default devise modules. Others available are: :confirmable, :lockable, and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :timeoutable

  has_many :grams, inverse_of: :user, dependent: :destroy
  has_many :comments, inverse_of: :user, dependent: :destroy
end