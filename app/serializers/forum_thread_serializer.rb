class ForumThreadSerializer
  include FastJsonapi::ObjectSerializer
  attributes :title, :description, :author, :created_at, :cached_weighted_score, :tags

  belongs_to :author
  has_many :comments
end
