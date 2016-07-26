json.array!(@musics) do |music|
  json.extract! music, :id, :band, :track
  json.url music_url(music, format: :json)
end
