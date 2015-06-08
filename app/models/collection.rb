class Collection < ActiveRecord::Base
  belongs_to :user
  has_many :videos, through: :collections_videos
end
