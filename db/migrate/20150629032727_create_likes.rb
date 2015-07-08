class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.integer :user_id
      t.integer :video_id

      t.timestamps null: false
    end
    add_index :likes, [:user_id, :video_id], unique: true
  end
end
