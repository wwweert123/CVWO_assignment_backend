class Author < ApplicationRecord
    acts_as_voter
    has_secure_password

    has_many :comments
    has_many :forum_threads
    
    validates :name, :uniqueness => true
end
