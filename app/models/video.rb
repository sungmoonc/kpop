class Video < ActiveRecord::Base
  has_many :collections, through: :collections_videos
  has_many :artists, through: :artists_videos

  validates :youtube_id, uniqueness: true

  def approval_rating
    ((self.upvotes/(self.upvotes + self.downvotes).to_f) * 100).round(2)
  end

  def upvotes_per_views
    ((self.upvotes/self.youtube_views.to_f) * 100).round(2)
  end
end

