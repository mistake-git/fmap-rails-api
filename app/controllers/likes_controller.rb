class LikesController < ApplicationController
  before_action :set_post
  before_action :set_like, except: [:index, :create, :my_like]
  before_action :auth
  before_action :require_auth

  def create
    like = Like.first_or_create!(user_id: @current_user.id, post_id: @post.id)
    @post.create_notification_like(@current_user)
    render json: like
  end

  def my_like
    like = Like.find_by(post_id: @post.id, user_id: @current_user.id)
    render json: like
  end

  def destroy
    @like.destroy
  end

  private

  def set_like
    @like = Like.find(params[:id])
  end

  def set_post
    @post = Post.find(params[:post_id])
  end

end
