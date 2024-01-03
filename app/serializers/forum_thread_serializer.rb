class ForumThreadSerializer
  include FastJsonapi::ObjectSerializer
  attributes :title, :description, :upvotes

  belongs_to :author
  has_many :comments
end
