class Post < ActiveRecord::Base
    serialize :left
    serialize :right
    serialize :tags
    serialize :links
end
