class CreateArticles < ActiveRecord::Migration[6.0]
  def up
    execute <<-SQL
      CREATE TYPE article_type AS ENUM ('blog_post', 'facebook', 'tweet');
    SQL

    create_table :articles do |t|
      t.column :type, :article_type, index: true
      t.string :name
      t.text :text

      t.timestamps
    end

    add_index :articles, "to_tsvector('english', name || ' ' || text)", using: :gin
  end

  def down
    drop_table :articles

    execute <<-SQL
      DROP TYPE article_type;
    SQL
  end
end
