class Comment < ApplicationRecord
  acts_as_votable
  
  belongs_to :forum_thread
  belongs_to :author
end
