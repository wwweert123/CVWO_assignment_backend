class CommentSerializer
  include FastJsonapi::ObjectSerializer
  attributes :text, :author, :forum_thread_id, :created_at, :forum_thread

  belongs_to :author
end
