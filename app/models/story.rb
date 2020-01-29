# Scope for different Articles
class Story < ApplicationRecord
  has_many :articles, dependent: :destroy

  validates :name, presence: true
end
