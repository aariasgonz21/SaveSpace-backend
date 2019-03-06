class Api::V1::UsersController < ApplicationController
  skip_before_action :authorized, only: [:create, :index]

  def index
    @users = User.all
    render json: @users
  end

  # def show
  #   @user = User.find(params[:id])
  #
  #   render json: {@user}, serializer: UserSerializer
  # end

  def profile
    @user = UserSerializer.new(current_user)
    #byebug
    @reviews = User.find(current_user.id).reviews
   render json: { user: @user, user_reviews: @reviews }, status: :accepted
  end

  def create
    @user = User.create(user_params)
    if @user.valid?
      @token = encode_token({user_id: @user.id})
      render json: { user: UserSerializer.new(@user), jwt: @token }, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :not_acceptable
    end
  end

  private
  def user_params
    params.require(:user).permit(:username, :password, :bio, :avatar, :first_name, :reviews)
  end
end
