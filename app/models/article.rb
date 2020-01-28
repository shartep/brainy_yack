# Article encapsulate data about different type of posts
class Article < ApplicationRecord
  self.inheritance_column = '_type'

  TYPES = %i[blog_post facebook tweet].freeze

  enum type: TYPES.to_h { |t| [t, t.to_s] }, _suffix: true

  validates :type, presence: true

  belongs_to :story
end
