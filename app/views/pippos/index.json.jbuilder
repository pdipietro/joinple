json.array!(@pippos) do |pippo|
  json.extract! pippo, :id, :pluto
  json.url pippo_url(pippo, format: :json)
end
