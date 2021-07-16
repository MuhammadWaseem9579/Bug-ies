class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true
  validates :user_type, presence: true

  has_many :projects , dependent: :destroy
  has_many :my_bugs, dependent: :destroy

  has_many :users_projects
  has_many :projects, through: :users_projects 

end
