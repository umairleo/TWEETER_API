json.extract! tweet, :id, :body, :created_at, :updated_at
json.user do
  json.email tweet.user.email
  json.name tweet.user.name
  json.username tweet.user.username
end