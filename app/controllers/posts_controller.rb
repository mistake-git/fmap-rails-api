class PostsController < ApplicationController
  include Rails.application.routes.url_helpers
  before_action :set_post, only: [:show, :data, :likes, :likes_users, :update, :destroy, :ranking]

  def search
    posts = Post.search(params[:search]).order(created_at: :desc)
    render json: posts
  end

  def get_lat_lng
    results = Geocoder.search(params[:address])
    lat_lng = results.first.coordinates
    lat = lat_lng[0]
    lng = lat_lng[1]
    render json: {
      lat: lat_lng[0],
      lng: lat_lng[1]
    }
  end

  def map
    posts = Post.all.order(created_at: :desc).limit(100)
    render json: posts
  end

  def index
    posts = Post.page(params[:page]).per(4).order(created_at: :desc)
    render json: posts
  end

  def show
    user = @post.user
    render json: @post
  end

  def data
    same_name_post = Post.where(name: @post.name)
    size_data = same_name_post.where.not(size: nil).group(:size).sum(:number)
    feed_data = same_name_post.where.not(feed: '').group(:feed).sum(:number)
    date_data = same_name_post.where.not(date: nil).group('MONTH(date)').sum(:number)
    time_data = same_name_post.where.not(time: nil).group('HOUR(time)').sum(:number)
    render json:
    {
      feed_data: feed_data,
      time_data: time_data,
      date_data: date_data,
      size_data: size_data
    }
  end

  def ranking
    posts = Post.where(name: @post.name).where('size IS NOT NULL').order(size: 'DESC').limit(8)
    render json:  posts
  end

  def likes_users
    likes_users = @post.likes_users
    render json: likes_users
  end

  def create
    post = Post.new(post_params)
    if post.save!
      render json: post
    else
      render json: post.errors
    end
  end

  def update
    if @post.update(post_params)
      render json: @post
    else
      render json: @post.errors
    end
  end

  def destroy
    @post.destroy
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.permit(:id, :user_id, :name, :size, :weather, :weight, :date, :time, :number, :feed, :memo, :latitude,
                  :longitude, :image)
  end
end
