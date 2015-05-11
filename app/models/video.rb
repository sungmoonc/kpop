class Video < ActiveRecord::Base

  validates :youtube_id, uniqueness: true

end
