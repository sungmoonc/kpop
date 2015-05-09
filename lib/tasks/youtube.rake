require 'google/api_client'
require 'trollop'

namespace :youtube do
  desc "TODO"
  task fetch: :environment do

    # Set DEVELOPER_KEY to the "API key" value from the "Access" tab of the
    # Google Developers Console <https://cloud.google.com/console>
    # Please ensure that you have enabled the YouTube Data API for your project.
    DEVELOPER_KEY = "AIzaSyDMO3g93mpDZqmr9IBGmuKL1OwV7BHUYc0"
    YOUTUBE_API_SERVICE_NAME = "youtube"
    YOUTUBE_API_VERSION = "v3"

    opts = Trollop::options do
      opt :q, 'Search term', :type => String, :default => 'kpop'
      opt :maxResults, 'Max results', :type => :int, :default => 25
    end

    client = Google::APIClient.new(:key => DEVELOPER_KEY,
                                   :authorization => nil)
    youtube = client.discovered_api(YOUTUBE_API_SERVICE_NAME, YOUTUBE_API_VERSION)

    opts[:part] = 'id,snippet'

    search_response = client.execute!(
      :api_method => youtube.search.list,
      :parameters => opts
    )

    search_response.data.items.each do |search_result|
      case search_result.id.kind
        when 'youtube#video'
          p search_result.snippet
      end
    end


  end
end
