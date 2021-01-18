class Rating < Sequel::Model
  plugin :json_serializer
  one_to_one :songs
  one_to_one :users
end
