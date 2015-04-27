class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :url
      t.string :artist
      t.string :korean_title
      t.string :english_title
      t.text :description
      t.string :artist_gender
      t.integer :hotness
      t.integer :cuteness
      t.integer :english_lyrics
      t.integer :subtitle
      t.integer :official
      t.integer :views

      t.timestamps null: false
    end
  end
end
