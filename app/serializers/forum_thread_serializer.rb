class ForumThreadSerializer
  include FastJsonapi::ObjectSerializer
  attributes :title, :description, :upvotes

  has_many :comments
end
