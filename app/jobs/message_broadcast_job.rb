class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(data)
    message = Message.create!(body: data['message'], conversation_id: data['conversation_id'], user_id: data['current_user_id'])
    ActionCable.server.broadcast "conversations_#{message.conversation.id}_channel",
      message: render_message(message)
  end

  private

  def render_message(message)
    MessagesController.render partial: 'messages/message', locals: {message: message}
  end
end
