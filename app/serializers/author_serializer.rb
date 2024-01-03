class AuthorSerializer
    include FastJsonapi::ObjectSerializer
    attributes :name 

    has_many :comments 
    has_many :forum_threads
  end
  