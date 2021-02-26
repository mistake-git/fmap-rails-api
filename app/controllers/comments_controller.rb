class CommentsController < ApplicationController
  before_action :set_post, only: [:index, :create]
  before_action :set_comment, only: [:update, :destroy]
  before_action :auth, except: [:index]
  before_action :require_auth, except: [:index]

  def index
    comments = @post.comments.page(params[:page]).per(1).order(created_at: :desc)
    render json: comments
  end

  def create
    comment = Comment.new(
      comment_params.merge(post_id: @post.id, user_id: @current_user.id)
    )
    if comment.save
      @post.create_notification_comment(@current_user, comment.id)
      render json: comment
    else
      render json: comment.errors
    end
  end

  def update
    if @comment.update(comment_params)
      render json: @comment
    else
      render json: @comment.error
    end
  end

  def destroy
    @comment.destroy
  end

  private

  def comment_params
    params.require(:comment).permit(:id, :content)
  end

  def set_post
    @post = Post.find(params[:post_id])
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end
end
