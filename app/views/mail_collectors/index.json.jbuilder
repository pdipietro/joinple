json.array!(@mail_collectors) do |mail_collector|
  json.extract! mail_collector, :id, :email
  json.url mail_collector_url(mail_collector, format: :json)
end
