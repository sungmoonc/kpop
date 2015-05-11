class CollectionsVideo < ActiveRecord::Base
  belongs_to :collection
  belongs_to :video

end
