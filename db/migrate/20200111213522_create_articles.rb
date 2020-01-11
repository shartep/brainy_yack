class CreateArticles < ActiveRecord::Migration[6.0]
  def up
    execute <<-SQL
      CREATE TYPE article_type AS ENUM ('blog_post', 'facebook', 'tweet');
    SQL

    create_table :articles do |t|
      t.string :name
      t.text :text

      t.timestamps
    end
    add_column :articles, :type, :article_type

    add_index :articles, "to_tsvector('english', name || ' ' || text)", using: :gin
    add_index :articles, :type
  end

  def down
    drop_table :articles

    execute <<-SQL
      DROP TYPE article_type;
    SQL
  end
end
