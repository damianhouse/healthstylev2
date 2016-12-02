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
  validates :primary_coach, presence: true, if: :is_user?
  validates :secondary_coach, presence: true, if: :is_user?
  validates :tertiary_coach, presence: true, if: :is_user?
  validate :all_coaches_unique, if: :is_user?
  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/generic_avatar.jpg"
  validates_attachment_content_type :avatar, content_type: /\Aimage\//

  private

  def all_coaches_unique
    coaches = [primary_coach, secondary_coach, tertiary_coach]
    coaches.count == coaches.uniq.count
  end

  def is_user?
    is_admin == false && is_coach == false
  end

  def is_coach?
    self.is_coach
  end

  def is_admin?
    self.is_admin
  end
end
