json.array!(@social_networks) do |social_network|
  json.extract! social_network, :id, :name, :description
  json.url social_network_url(social_network, format: :json)
end
