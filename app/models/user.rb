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

  private

    def is_coach?
      self.is_coach
    end

    def is_admin?
      self.is_admin
    end
end
