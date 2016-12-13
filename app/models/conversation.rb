class Conversation < ApplicationRecord
  belongs_to :user
  belongs_to :coach, class_name: "User"
  has_many :messages, dependent: :destroy
  validates :coach, uniqueness: {scope: :user}
end
