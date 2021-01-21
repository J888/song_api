class Song < Sequel::Model
  plugin :json_serializer

  one_to_many :unique_views
  many_to_many :tags
  many_to_one :users # author
  one_to_many :ratings
  many_to_many :genres

  dataset_module do
    def with_full_info(id)
      song = first(id: id)
      puts song
      ratings = Rating.where(song_id: song.id)
      sum_of_ratings = ratings.map { |r| r[:value] }.sum
      calculated_rating = if ratings.count > 0
                            sum_of_ratings.to_f / ratings.count.to_f
                          else
                            nil
                          end

      song_hash = JSON.parse(song.to_json)
      song_hash[:tags] = song.tags.map { |t| t[:value] } 
      song_hash[:genres] = song.genres.map { |g| g[:name] } 
      song_hash[:rating] = calculated_rating
      song_hash[:unique_views] = song.unique_views.count
      song_hash
    end

    def all_with_full_info
      all.map do |song|
        with_full_info(song.id)   
      end
    end

    def all_by_tag(tag_value)
      tag = Tag.first(value: tag_value)
      return [] if tag.nil?

      matches = DB[:songs].join(:songs_tags, song_id: :id).where(tag_id: tag.id).all
      song_ids = matches.map { |match| match[:song_id] }

      song_ids.map { |id| with_full_info(id) }
    end

    def all_by_genre(genre_name)
      genre = Genre.first(name: genre_name)
      return [] if genre.nil?

      matches = DB[:songs].join(:genres_songs, song_id: :id).where(genre_id: genre.id).all
      song_ids = matches.map { |match| match[:song_id] }

      song_ids.map { |id| with_full_info(id) }
    end

    #
    #  {
    #     "genre_name": [songs],
    #     ...
    #  }
    #
    def all_mapped_by_genre
      genres = Genre.all
      genre_ids = genres.map { |g| g[:id] }
      songs = []
      genre_ids.each do |genre_id|
        songs << DB[:songs].join(:genres_songs, song_id: :id).where(genre_id: genre_id).all
      end
      
      songs = songs.flatten

      genre_name_to_songs_map = { }
      songs.each do |song|
        genre_id = song[:genre_id]
        genre_name = genres.find{ |genre| genre[:id] == genre_id }[:name]
        
        genre_name_to_songs_map[genre_name] ||= []
        genre_name_to_songs_map[genre_name] << with_full_info(song[:song_id])
      end

      genre_name_to_songs_map
    end
  end
end
