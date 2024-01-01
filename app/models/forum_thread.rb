class ForumThread < ApplicationRecord
    has_many :comments

    before_create :set_upvotes

    def set_upvotes
        self.upvotes = 0
    end
end
