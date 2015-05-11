require 'google/api_client'

def get_channels(client, entertainment, youtube)
  user_response = client.execute(
      :api_method => youtube.channels.list,
      :parameters => {
          :part => 'contentDetails',
          :forUsername => entertainment
      }
  )
  p user_response
  user_response
end

def create_new_video(video)
  new_video = Video.new
  # new_video.url = video.
  new_video.youtube_id = video.snippet.resourceId.videoId
  new_video.title_korean = video.snippet.title
  new_video.description = video.snippet.description
  new_video.thumbnail = video.snippet.thumbnails["medium"]["url"]

  new_video.save
end

def get_videos(client, user_response, youtube)
  user_response.data.items.each do |item|
    pid = item.contentDetails.relatedPlaylists.uploads

    video_response = client.execute(
        :api_method => youtube.playlist_items.list,
        :parameters => {
            :playlistId => pid,
            :part => 'snippet,contentDetails,id,status',
            :maxResults => 50
        }
    )

    p video_response

    # page_token = video_response.next_page_token
    #
    #
    # while(true) do
    #   video_response = client.execute!(
    #       :api_method => youtube.playlist_items.list,
    #       :parameters => {
    #           :playlistId => pid,
    #           :part => 'snippet,contentDetails',
    #           :pageToken => page_token
    #       }
    #   )
    #
    # page_token = video_response.next_page_token
    #
    #   break if page_token == nil

    video_response.data.items.each do |video|
      puts
      puts
      p video
      create_new_video(video)
    end

    # end
  end
end

namespace :youtube do
  desc "TODO"
  task fetch: :environment do

    entertainments = %w"100ayeon 15andOfficial 2am 2NE1 2pm 4minuteofficial abentofficial AceOfAngels8 ALi091008 alphaentkorea amoebakorea amusekr apinkTV applegirl002 b2ment b2mysofficial babysoulhome beastofficial BIGBANG BoAsmtown#p/p BoysRepublicOfficial Brandnewmusickorea BrandnewStardom/videos bravefamily brianjoomusic cclownofficial chB1A4 chHelloVenus CJENMMUSIC CJESJYJ cnblue coremidas crayonpopvideo DBusinessENT dlineartmedia DMTNofficial drunkentiger DSP/videos dspAJAX DSPKara entertainmentCUBE EXCELLENTENTofficial EXOK EXOM fcuz0108 FNCMUSICofficial fncohwonbin ftisland fxsmtown girlsday5 GIRLSGENERATION GLAMofficialvideo gnaofficial GoodFellasTVch1 happyfaceent HISTORYloen ibighit infinitehome IVYofficialChannel jaybumaom0425#p/u jaykentertainment/videos Jellyfishenter jewelry0127 JJprojectOfficial joojype jtunecamp jypark jypentertainment kimhyunjoong606 LadiesCode lbdemion leehyoriofficial LOENARTIST LOENENT loenFIESTAR loenIU loenSUNNYHILL loenZIA mapthesoul MIBOfficial missA mnet MrJangwoohyuk neganetwork NeuroNTV/videos NEWPLANETwebmaster NextarEntertainment NineMusesCh officialBEG officialbtob OfficialEpikHigh OfficialGDRAGON OfficialJUNIEL officialLC9 OfficialLEEHI officialLUNAFLY officialpsy officialroykim OfficialSe7en OfficialSEUNGRI OfficialSEUNGYOON OfficialTheRainbow OfficialTMent OFFICIALYNB OFFROAD0924 onewayonesound OPENWORLDent parkjiyooncreative pastelmusic pledis17 pledisartist pledisnuest PolarisMusicOfficial princeJKS PUREENTER RealTinyG RealVIXX RockinKOREAent royalpiratesband SHINee SHINHWACOMPANY SHINHWACOMPANY sment SMTOWN soundholicENT spicaofficial Starempireofficial starshipTV SUPERJUNIOR supervocaltomtom TAILLRUNSMEDIA TeenzOnTop TheAziatix TheCANENT TheMRMRofficial TheRealChocolat TimeZOfficial2012 Top100percent TOPmediaStar Trophyentertainment1 Troublemakerofficial#g/u TSENT2008 TVXQ ukiss2008 wondergirls woolliment YeDangCompany ygentertainment ygtablo YGTAEYANG YMCent ZEA2011"

    entertainments = ["smtown"]
    DEVELOPER_KEY = ENV["YOUTUBE_KEY"]
    YOUTUBE_API_SERVICE_NAME = "youtube"
    YOUTUBE_API_VERSION = "v3"

    client = Google::APIClient.new(:key => DEVELOPER_KEY,
                                   :authorization => nil,
                                   :application_name => 'Hello World',
                                   :application_version => '1.0.0')

    youtube = client.discovered_api(YOUTUBE_API_SERVICE_NAME, YOUTUBE_API_VERSION)

#['smtown']

    entertainments.each do |entertainment|
      user_response = get_channels(client, entertainment, youtube)

      get_videos(client, user_response, youtube)


    end


  end
end
