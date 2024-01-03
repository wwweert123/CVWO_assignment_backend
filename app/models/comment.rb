class Comment < ApplicationRecord
  belongs_to :forum_thread
  belongs_to :author
end
