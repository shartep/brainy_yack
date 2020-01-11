# Article encapsulate data about different type of posts
class Article < ApplicationRecord
  self.inheritance_column = '_type'

  TYPES = %i[blog_post facebok tweet].freeze
  enum type: { blog_post: '' }
  belongs_to :story
end
