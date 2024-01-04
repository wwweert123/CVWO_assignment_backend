class Author < ApplicationRecord
    has_many :comments
    has_many :forum_threads
    
    validates :name, :uniqueness => true
end
