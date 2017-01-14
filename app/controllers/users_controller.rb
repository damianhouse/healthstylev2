class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :set_coaches, only: [:new, :edit, :update]
  before_action :authenticate_user!, except: [:show]
  before_action :authenticate_admin!, except: [:show]
  before_action :is_authorized?, only: [:show]
  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @primary_coach = User.find(@user.primary_coach) if @user.primary_coach
    @secondary_coach = User.find(@user.secondary_coach) if @user.secondary_coach
    @tertiary_coach = User.find(@user.tertiary_coach) if @user.tertiary_coach
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end


  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
      if @user.save
        create_conversations(@user)
        if Rails.env == 'production'
          UserMailer.welcome(@user).deliver_now
        end
      end
    end
  end
  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    @user.update_attributes(user_params)
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

  private
    # Use callbacks to share common setup or constraints between actions.

    def is_authorized?
      if current_user
        unless @user.is_coach || @user == current_user || current_user.is_admin || current_user.is_coach && @user.is_admin == false
          redirect_to root_path
        end
      else
        unless @user.is_coach
          redirect_to root_path
        end
      end
    end

    def set_coaches
      @coaches = User.where("is_coach = ? AND approved = ?", true, true)
    end

    def set_user
      @user = User.find(params[:id])
    end

    def authenticate_admin!
      redirect_to root_path unless current_user.is_admin
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:first_name, :last_name, :avatar, :approved, :is_admin, :is_coach, :email, :primary_coach, :secondary_coach, :tertiary_coach, :greeting, :philosophy, :phone_number, :password, :password_confirmation, :terms_read, :expires_at)
    end
end
