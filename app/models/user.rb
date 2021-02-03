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

end
