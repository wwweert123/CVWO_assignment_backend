class CommentSerializer
  include FastJsonapi::ObjectSerializer
  attributes :text, :author, :forum_thread_id
end
