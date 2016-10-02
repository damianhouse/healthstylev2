class ConversationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @conversations = Conversation.all
  end

  def new
    @conversation = Conversation.new
  end

  def create
    @conversation = current_user.conversations.build(conversation_params)
    if @conversation.save
      flash[:success] = 'Conversation added!'
      redirect_to conversations_path
    else
      render 'new'
    end
  end
  def show
    @conversation = Conversation.includes(:messages).find_by(id: params[:id])

  end
  private

  def conversation_params
    params.require(:conversation).permit(:user_id, :coach_id)
  end
end
