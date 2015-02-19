json.array!(@tags) do |tag|
  json.extract! tag, :id, :text
  json.url tag_url(tag, format: :json)
end
