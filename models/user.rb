class User < Sequel::Model
  plugin :json_serializer
  one_to_many :songs
  many_to_one :ratings
end
