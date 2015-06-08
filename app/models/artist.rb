class Artist < ActiveRecord::Base
  has_many :videos, through: :artists_videos
end
