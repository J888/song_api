class Genre < Sequel::Model
  plugin :json_serializer
  many_to_many :songs
end
