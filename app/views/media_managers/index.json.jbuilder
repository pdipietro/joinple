json.array!(@media_managers) do |media_manager|
  json.extract! media_manager, :id
  json.url media_manager_url(media_manager, format: :json)
end
