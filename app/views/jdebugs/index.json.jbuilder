json.array!(@jdebugs) do |jdebug|
  json.extract! jdebug, :id
  json.url jdebug_url(jdebug, format: :json)
end
