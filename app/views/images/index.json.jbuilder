json.array!(@images) do |image|
  json.extract! image, :id, :class_name, :type_name, :attachment
  json.url image_url(image, format: :json)
end
