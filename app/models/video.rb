class Video < ActiveRecord::Base
  has_many :collections, through: :collections_videos
  has_many :artists, through: :artists_videos

  scope :category, -> (name) {where("category LIKE '#{name}'")}

  validates :youtube_id, uniqueness: true

end
