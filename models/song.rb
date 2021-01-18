class Song < Sequel::Model
  plugin :json_serializer

  one_to_many :unique_views
  many_to_many :tags
  many_to_one :users # author
  one_to_many :ratings
  many_to_many :genres

  dataset_module do
    def all_with_full_info
      all.map do |song|
        song[:tags] = song.tags
        song[:genres] = song.genres
        ratings = Rating.where(song_id: song.id)
        
        sum_of_ratings = ratings.map { |r| r[:value] }.sum
  
        calculated_rating = if ratings.count > 0
                              sum_of_ratings.to_f / ratings.count.to_f
                            else
                              nil
                            end
        song_hash = JSON.parse(song.to_json)

        song_hash[:rating] = calculated_rating
        song_hash
        
      end
    end
  end
end
