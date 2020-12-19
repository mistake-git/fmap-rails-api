class Post < ApplicationRecord
  include Rails.application.routes.url_helpers
  validates :name, presence: true, format: { with: /\A[\p{katakana}\p{blank}ー－]+\z/ }
  validates :latitude, presence: true
  validates :longitude, presence: true
  belongs_to :user
  has_one_attached :image
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :likes_users, through: :likes, source: :user

  def image_url
    image.attached? ?  url_for(image) : nil
  end

  def self.search(search)
    if search
      Post.where(['name LIKE ?', "%#{search}%"])
    else
      Post.all
    end
  end
  
end
