class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :authenticate_admin!, only: [:index]
  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
    session[:user] = nil
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    case step
    when :create_user
      @user = User.new(user_params)
      session[:user] = @user.attributes
      redirect_to next_wizard_path
    when :add_coaches
      session[:user] = session[:user].merge(params[:user])
      @user = User.new(session[:user])
      @user.save
      redirect_to user_path(@user)
    end
    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def choose_coaches
    @user = current_user
    @coaches = User.where("is_coach = ? AND approved = ?", true, true)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def finish_wizard_path
      user_path(@user)
    end

    def set_user
      @user = User.find(params[:id])
    end

    def authenticate_admin!
      redirect_to root_path unless current_user.is_admin
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:first_name, :last_name, :avatar, :approved, :is_admin, :is_coach, :email, :primary_coach, :secondary_coaches, :greeting, :philosophy, :phone_number)
    end
end
