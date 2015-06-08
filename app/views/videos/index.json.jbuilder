json.array!(@videos) do |video|
  json.extract! video, :id, :url, :artist, :korean_title, :english_title, :description, :artist_gender, :hotness, :cuteness, :english_lyrics, :subtitle, :official, :views, :up, :down
  json.url video_url(video, format: :json)
end
