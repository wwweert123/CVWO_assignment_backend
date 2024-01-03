class Author < ApplicationRecord
    has_many :comments
    has_many :forum_threads
end
