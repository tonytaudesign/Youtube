json.array!(@sweets) do |sweet|
  json.extract! sweet, :id
  json.url sweet_url(sweet, format: :json)
end
