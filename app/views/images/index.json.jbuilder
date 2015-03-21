json.array!(@images) do |image|
  json.extract! image, :id, :image
  json.url image_url(image, format: :json)
end
