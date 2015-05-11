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
      t.integer :hotness
      t.integer :cheesiness
      t.integer :english_percentage
      t.integer :english_subtitle
      t.integer :official
      t.integer :youtube_views
      t.date :upload_date
      t.integer :upvotes
      t.integer :downvotes

      t.timestamps null: false
    end
  end
end
