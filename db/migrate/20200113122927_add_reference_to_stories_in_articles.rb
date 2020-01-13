class AddReferenceToStoriesInArticles < ActiveRecord::Migration[6.0]
  def change
    add_reference :articles, :story
  end
end
