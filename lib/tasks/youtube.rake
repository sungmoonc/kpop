require 'google/api_client'
require 'trollop'

namespace :youtube do
  desc "TODO"
  task fetch: :environment do

    # Set DEVELOPER_KEY to the "API key" value from the "Access" tab of the
    # Google Developers Console <https://cloud.google.com/console>
    # Please ensure that you have enabled the YouTube Data API for your project.
    DEVELOPER_KEY = ""
    YOUTUBE_API_SERVICE_NAME = "youtube"
    YOUTUBE_API_VERSION = "v3"

    opts = Trollop::options

    client = Google::APIClient.new(:key => DEVELOPER_KEY,
                                   :authorization => nil,
                                   :application_name => 'Hello World',
                                   :application_version => '1.0.0')
    youtube = client.discovered_api(YOUTUBE_API_SERVICE_NAME, YOUTUBE_API_VERSION)

    user_response = client.execute!(
      :api_method => youtube.channels.list,
      :parameters => {
        :part => 'contentDetails',
        :forUsername => 'smtown'
      }
    )

    user_response.data.items.each do |item|
      pid = item.contentDetails.relatedPlaylists.uploads

      opts_vid = Trollop::options

      opts_vid[:part] = "snippet"
      opts_vid[:playlistId] = "pid"

      video_response = client.execute!(
        :api_method => youtube.playlist_items.list,
        :parameters => {
          :playlistId => pid,
          :part => 'snippet'
        }
      )

      p video_response

    end


  end
end