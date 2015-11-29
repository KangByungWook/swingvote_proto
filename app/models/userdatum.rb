class Userdatum < ActiveRecord::Base
    serialize :main_tag
    serialize :tags
    serialize :posts
end
