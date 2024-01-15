class CommentSerializer
  include FastJsonapi::ObjectSerializer
  attributes :text, :author, :forum_thread_id, :created_at, :forum_thread, :cached_weighted_score

  belongs_to :author
end
