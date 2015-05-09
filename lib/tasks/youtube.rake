require 'google/api_client'

namespace :youtube do
  desc "TODO"
  task fetch: :environment do

    DEVELOPER_KEY = ENV["YOUTUBE_KEY"]
    YOUTUBE_API_SERVICE_NAME = "youtube"
    YOUTUBE_API_VERSION = "v3"

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

      video_response = client.execute!(
        :api_method => youtube.playlist_items.list,
        :parameters => {
          :playlistId => pid,
          :part => 'snippet,contentDetails'
        }
      )

      page_token = video_response.next_page_token


      while(true) do
        video_response = client.execute!(
            :api_method => youtube.playlist_items.list,
            :parameters => {
                :playlistId => pid,
                :part => 'snippet,contentDetails',
                :pageToken => page_token
            }
        )
        page_token = video_response.next_page_token
        video_response.data.items.each do |video|


          new_video = Video.new
          new_video.youtube_id = video.id
          new_video.title_korean = video.snippet.title
          new_video.description = video.snippet.description
          new_video.thumbnail = video.snippet.thumbnails["medium"]["url"]

          new_video.save
        end
      end


    end


  end
end
