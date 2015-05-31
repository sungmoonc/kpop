class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :youtube_id
      t.string :thumbnail
      t.string :artist
      t.string :title_korean
      t.string :title_english
      t.string :youtube_user_id
      t.text :description
      t.integer :hotness, :default => 0
      t.integer :cheesiness, :default => 0
      t.integer :english_percentage, :default => 0
      t.boolean :english_subtitle, :default => false
      t.boolean :official, :default => false
      t.integer :youtube_views, limit: 8
      t.string :definition
      t.integer :duration
      t.string :dimension
      t.string :caption
      t.string :category
      t.boolean :licensed_content
      t.date :upload_date
      t.integer :upvotes, limit: 8
      t.integer :downvotes, limit: 8

      t.timestamps null: false
    end
  end
end
