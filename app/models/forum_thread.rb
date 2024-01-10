class ForumThread < ApplicationRecord
    acts_as_votable
    acts_as_taggable_on :tags

    has_many :comments
    belongs_to :author
end
