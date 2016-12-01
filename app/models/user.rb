class User < ApplicationRecord
  # Include default devise modules. Others available are:
  #   :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :conversations, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :notes, dependent: :destroy
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :phone_number, presence: true
  validates :greeting, presence: true, if: :is_coach?
  validates :philosophy, presence: true, if: :is_coach?
  validates_uniqueness_of :email, allow_blank: true
  serialize :secondary_coaches
  serialize :secondary_users
  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/generic_avatar.jpg"
  validates_attachment_content_type :avatar, content_type: /\Aimage\//
end
