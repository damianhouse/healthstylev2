class Message < ApplicationRecord
  belongs_to :user
  belongs_to :conversation

  def timestamp
    created_at.strftime('%H:%M:%S %d %B %Y')
  end
end
