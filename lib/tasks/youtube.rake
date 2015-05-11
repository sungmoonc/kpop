#require 'google/api_client'


def create_new_video(video)
  new_video = Video.new
  # new_video.url = video.
  new_video.youtube_id = video.snippet.resourceId.videoId
  new_video.title_korean = video.snippet.title
  new_video.description = video.snippet.description
  new_video.thumbnail = video.snippet.thumbnails["medium"]["url"]

  new_video.save
end

def get_video_ids(client, user_response, youtube)
  item = user_response.data.items.first
  pid = item.contentDetails.relatedPlaylists.uploads

  video_response = client.execute(
    :api_method => youtube.playlist_items.list,
    :parameters => {
      :playlistId => pid,
      :part => 'contentDetails',
      :maxResults => 50
    }
  )

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

  video_response.data.items.map do |item|
    item.contentDetails.videoId
  end
end

def youtube_api(method, options)
  options_string = options.map do |option|
    option[0].to_s + "=" + option[1].to_s
  end.join("&")

  url = "https://www.googleapis.com/youtube/v3/#{method}?" + options_string + "&key=#{DEVELOPER_KEY}"
  puts url

  http = Curl.get(url)

  JSON.parse(http.body_str)
end

entertainments = %w"100ayeon 15andOfficial 2am 2NE1 2pm 4minuteofficial abentofficial AceOfAngels8 ALi091008 alphaentkorea amoebakorea amusekr apinkTV applegirl002 b2ment b2mysofficial babysoulhome beastofficial BIGBANG BoAsmtown#p/p BoysRepublicOfficial Brandnewmusickorea BrandnewStardom/video_ids bravefamily brianjoomusic cclownofficial chB1A4 chHelloVenus CJENMMUSIC CJESJYJ cnblue coremidas crayonpopvideo DBusinessENT dlineartmedia DMTNofficial drunkentiger DSP/video_ids dspAJAX DSPKara entertainmentCUBE EXCELLENTENTofficial EXOK EXOM fcuz0108 FNCMUSICofficial fncohwonbin ftisland fxsmtown girlsday5 GIRLSGENERATION GLAMofficialvideo gnaofficial GoodFellasTVch1 happyfaceent HISTORYloen ibighit infinitehome IVYofficialChannel jaybumaom0425#p/u jaykentertainment/video_ids Jellyfishenter jewelry0127 JJprojectOfficial joojype jtunecamp jypark jypentertainment kimhyunjoong606 LadiesCode lbdemion leehyoriofficial LOENARTIST LOENENT loenFIESTAR loenIU loenSUNNYHILL loenZIA mapthesoul MIBOfficial missA mnet MrJangwoohyuk neganetwork NeuroNTV/video_ids NEWPLANETwebmaster NextarEntertainment NineMusesCh officialBEG officialbtob OfficialEpikHigh OfficialGDRAGON OfficialJUNIEL officialLC9 OfficialLEEHI officialLUNAFLY officialpsy officialroykim OfficialSe7en OfficialSEUNGRI OfficialSEUNGYOON OfficialTheRainbow OfficialTMent OFFICIALYNB OFFROAD0924 onewayonesound OPENWORLDent parkjiyooncreative pastelmusic pledis17 pledisartist pledisnuest PolarisMusicOfficial princeJKS PUREENTER RealTinyG RealVIXX RockinKOREAent royalpiratesband SHINee SHINHWACOMPANY SHINHWACOMPANY sment SMTOWN soundholicENT spicaofficial Starempireofficial starshipTV SUPERJUNIOR supervocaltomtom TAILLRUNSMEDIA TeenzOnTop TheAziatix TheCANENT TheMRMRofficial TheRealChocolat TimeZOfficial2012 Top100percent TOPmediaStar Trophyentertainment1 Troublemakerofficial#g/u TSENT2008 TVXQ ukiss2008 wondergirls woolliment YeDangCompany ygentertainment ygtablo YGTAEYANG YMCent ZEA2011"

entertainments = ["smtown"]

DEVELOPER_KEY = ENV["YOUTUBE_KEY"]

def get_user_videos(entertainment)
  channels = youtube_api("channels", {
    part: "contentDetails",
    forUsername: entertainment,
    maxResults: 50
  })
  upload_channel = channels["items"].first["contentDetails"]["relatedPlaylists"]["uploads"]

  video_ids = youtube_api("playlistItems", { playlistId: upload_channel,
                                             part: 'contentDetails',
                                             maxResults: 50 })
  #p  video_ids["nextPageToken"]

  video_ids["items"].map do |item|
    item["contentDetails"]["videoId"]
  end
end

def get_video_details(video_ids)
  youtube_api("videos", {
    :id => video_ids.join(","),
    :part => 'snippet,statistics',
    :maxResults => 50
  })["items"]
end

namespace :youtube do
  desc "TODO"
  task fetch: :environment do

    entertainments.each do |entertainment|
      video_ids = get_user_videos(entertainment)
      video_details = get_video_details(video_ids)

      p video_details

    end

  end
end
