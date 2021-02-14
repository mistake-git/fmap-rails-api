class NotificationSerializer < ActiveModel::Serializer
  attributes :id, :post, :comment, :visitor, :created_at, :action
  belongs_to :post, serializer: PostSerializer
  belongs_to :comment, serializer: CommentSerializer
  belongs_to :visitor, serializer: UserSerializer
  belongs_to :visited, serializer: UserSerializer
end
