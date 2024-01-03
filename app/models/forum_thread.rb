class ForumThread < ApplicationRecord
    has_many :comments
    belongs_to :author

    before_create :set_upvotes

    def set_upvotes
        self.upvotes = 0
    end
end
