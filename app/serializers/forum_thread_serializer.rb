class ForumThreadSerializer
  include FastJsonapi::ObjectSerializer
  attributes :title, :description, :upvotes, :author, :created_at

  belongs_to :author
  has_many :comments
end
