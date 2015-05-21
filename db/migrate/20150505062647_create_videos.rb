class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :youtube_id
      t.string :thumbnail
      t.string :artist
      t.string :title_korean
      t.string :title_english
      t.string :youtube_user_id
      t.string :category
      t.text :description
      t.integer :hotness
      t.integer :cheesiness
      t.integer :english_percentage
      t.integer :english_subtitle
      t.integer :official
      t.integer :youtube_views, limit: 8
      t.string :definition
      t.string :duration
      t.string :dimension
      t.string :caption
      t.boolean :licensed_content
      t.date :upload_date
      t.integer :upvotes, limit: 8
      t.integer :downvotes, limit: 8

      t.timestamps null: false
    end
  end
end
