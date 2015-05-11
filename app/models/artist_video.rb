class ArtistVideo < ActiveRecord::Base
  belongs_to :artist
  belongs_to :video
end
