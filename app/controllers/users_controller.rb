class UsersController < ApplicationController
  include Rails.application.routes.url_helpers
  before_action :set_user, only: [:show, :update, :posts, :likes_posts, :data, :followers, :followings, :feed]
  before_action :auth, only: [:update]
  before_action :require_auth, only: [:update]

  def search
    users = User.search(params[:search]).order(created_at: :desc)
    render json: users
  end

  def index
    users = User.page(params[:page]).per(4).order(created_at: :desc)
    render json: users
  end

  def create
    user = User.new(user_params)
    if user.save
      render json: user
    else
      render json: user.errors
    end
  end

  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors
    end
  end

  def show
    render json: @user
  end

  def posts
    posts = @user.posts.order(created_at: :desc)
    render json: posts
  end

  def likes_posts
    likes_posts = @user.likes_posts.order(created_at: :desc)
    render json: likes_posts
  end

  def followings
    followings = @user.followings
    render json: followings
  end

  def followers
    followers = @user.followers
    render json: followers
  end

  def feed
    posts = @user.feed.page(params[:page]).per(4).order(created_at: :desc)
    render json: posts
  end  

  def data
    fish_data = @user.posts.group(:name).sum(:number)
    month_data = @user.posts.group('MONTH(created_at)').count
    render json: {fish_data: fish_data, month_data: month_data}
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :uid, :introduction, :address, :latitude, :longitude)
  end

  def set_user
    @user = User.find_by(uid: params[:id])
  end
end
