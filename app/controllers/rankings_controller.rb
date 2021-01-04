class RankingsController < ApplicationController
  before_action :set_post

  def index
    posts = Post.where(name: @post.name).where("size IS NOT NULL").order(size: 'DESC').limit(8)
    render json:  posts
  end

  private
  
  def set_post
    @post = Post.find(params[:post_id])
  end
   
end
