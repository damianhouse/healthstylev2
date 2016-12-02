class ConversationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = current_user
    if @user.is_coach
      @coach = current_user
      @primary_users = User.where("primary_coach = ?", @user.id)
      @secondary_users = User.where("secondary_coach = ? OR tertiary_coach = ?", @user.id, @user.id)
    else
      @primary_coach = User.find(current_user.primary_coach) if @user.primary_coach
      @secondary_coaches = User.where("id = ? OR id = ?", @user.secondary_coach, @user.tertiary_coach)
    end
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
    @message = Message.new
    @current_user_id = current_user.id
    @other_user = @conversation.user unless @conversation.user_id == @current_user_id
    @other_user = User.find(@conversation.coach_id) unless @conversation.coach_id == @current_user_id
  end

  private

  def conversation_params
    params.require(:conversation).permit(:user_id, :coach_id)
  end
end
