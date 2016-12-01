class Note < ApplicationRecord
  belongs_to :user
  belongs_to :coach, class_name: "User"
end
