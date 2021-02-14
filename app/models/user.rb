class User < ApplicationRecord
  include Rails.application.routes.url_helpers
  validates :name, presence: true
  validates :email, presence: true
  validates :uid, presence: true
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :likes_posts, through: :likes, source: :post
  has_many :posts, dependent: :destroy
  has_one_attached :image
  geocoded_by :address
  after_validation :geocode
  has_many :relationships
  has_many :followings, through: :relationships, source: :follow
  has_many :reverse_of_relationships, class_name: 'Relationship', foreign_key: 'follow_id'
  has_many :followers, through: :reverse_of_relationships, source: :user
  has_many :active_notifications, class_name: 'Notification', foreign_key: 'visitor_id', dependent: :destroy
  has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy

  def image_url
    image.attached? ? url_for(image) : nil
  end

  def self.search(search)
    if search
      User.where(['name LIKE ?', "%#{search}%"])
    else
      User.all
    end
  end

  def follow(other_user)
    unless self == other_user
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end

  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end

  def following?(other_user)
    self.followings.include?(other_user)
  end

  #自分の投稿、フォロー中のユーザーの投稿を取得する
  def feed
    following_ids = "SELECT follow_id FROM relationships
                     WHERE user_id = :user_id"
    Post.where("user_id IN (#{following_ids})
                    OR user_id = :user_id", user_id: id)
  end 
  
  def create_notification_follow(current_user)
    temp = Notification.where(["visitor_id = ? and visited_id = ? and action = ? ",current_user.id, id, 'follow'])
    if temp.blank?
      notification = current_user.active_notifications.new(
        visited_id: id,
        action: 'follow'
      )
      notification.save if notification.valid?
    end
  end

end
