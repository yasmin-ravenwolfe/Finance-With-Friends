json.array!(@splits) do |split|
  json.extract! split, :id
  json.url split_url(split, format: :json)
end
