class Post < ApplicationRecord
  include Rails.application.routes.url_helpers
  default_scope -> { order(created_at: :desc) }
  validates :name, presence: true, format: { with: /\A[\p{katakana}\p{blank}ー－]+\z/ }
  validates :latitude, presence: true
  validates :longitude, presence: true
  validates :number, presence: true
  belongs_to :user
  has_one_attached :image
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :likes_users, through: :likes, source: :user
  has_many :notifications, dependent: :destroy

  def image_url
    image.attached? ? url_for(image) : nil
  end

  def self.search(search)
    if search
      Post.where(['name LIKE ?', "%#{search}%"])
    else
      Post.all
    end
  end

  def create_notification_like(current_user)
    # 自分の記事には通知を作成しない
    unless user_id === current_user.id
      notification = current_user.active_notifications.new(
      post_id: id,
      visited_id: user_id,
      action: "like"
      )
      notification.save if notification.valid?
    end
  end

  def create_notification_comment(current_user, comment_id)
    unless user_id === current_user.id
      # 自分以外にコメントしている人をすべて取得し、全員に通知を送る
      temp_ids = Comment.select(:user_id).where(post_id: id).where.not(user_id: current_user.id).distinct
      temp_ids.each do |temp_id|
        save_notification_comment(current_user, comment_id, temp_id["user_id"])
      end
      # まだ誰もコメントしていない場合は、投稿者に通知を送る
      save_notification_comment(current_user, comment_id, user_id) if temp_ids.blank?
    end
  end

  def save_notification_comment(current_user, comment_id, visited_id)
    # コメントは複数回することが考えられるため、１つの投稿に複数回通知する
    notification = current_user.active_notifications.new(
      post_id: id,
      comment_id: comment_id,
      visited_id: visited_id,
      action: "comment"
    )
    notification.save if notification.valid?
  end

end
