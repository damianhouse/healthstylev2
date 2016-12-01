class User < ApplicationRecord
  # Include default devise modules. Others available are:
  #   :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :conversations, dependent: :destroy
  has_many :messages, dependent: :destroy
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :phone_number, presence: true
  validates :greeting, presence: true, if: :is_coach?
  validates :philosophy, presence: true, if: :is_coach?
  validates_uniqueness_of :email, allow_blank: true
  serialize :secondary_coaches
  serialize :secondary_users

end
