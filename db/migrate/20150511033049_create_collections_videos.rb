class CreateCollectionsVideos < ActiveRecord::Migration
  def change
    create_table :collections_videos do |t|
      t.belongs_to :collection
      t.belongs_to :video

      t.timestamps null: false
    end
  end
end
