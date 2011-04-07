class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.string :title
      t.text :content
      t.string :slug
      t.boolean :is_active
      t.datetime :published_at

      t.timestamps
    end
    
    add_index :posts, :slug
  end

  def self.down
    drop_table :posts
  end
end
