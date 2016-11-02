class MessageUpdateBroadcastJob < ApplicationJob
  queue_as :default

  def perform(data)
    conversation_id = data['conversation_id']
    messages = Message.where('conversation_id = ? AND user_id != ? AND read = ?', data['conversation_id'], data['current_user_id'], false)
    messages.map {|x| x.read = true; x.save!}
    unless messages.empty?
      ActionCable.server.broadcast "conversations_#{conversation_id}_channel",
        messages: messages
    end
  end

end
