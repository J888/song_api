require 'rack/cors'

class AppMain < Roda
  use Rack::Cors, debug: true, logger: Logger.new(STDOUT) do
    allowed_methods = %i[get post put delete options head]
    allow do
      origins 'http://localhost:8080'
      resource '*', headers: :any, methods: allowed_methods
    end
  end

  plugin :json, classes: [Array, Hash, Sequel::Model]
  plugin :json_parser
  plugin :all_verbs
  plugin :halt

  route do |r|

    # GET list all songs
    r.on 'songs' do
      r.is do
        r.get do
          Song.all_with_full_info
        end
  
        r.post do
          current_date_time = DateTime.now
          params = r.params
  
          @tag = Tag.where(value: 'thetag').first
  
          @song = Song.create(
            title: params['title'],
            created_by_user_id: params['created_by_user_id'],
            artist: params['artist'],
            created_at: current_date_time,
            updated_at: current_date_time
          )
  
          @song.add_tag(@tag)
          @song
        end
      end

      r.get 'mapped_by_genre' do
        Song.all_mapped_by_genre
      end

      r.is String, method: :get do |id|
        Song.with_full_info(id)
      end
    end

    r.on 'songs_by_tag', String, method: :get do |tag_value|
      Song.all_by_tag(tag_value)
    end

    r.on 'songs_by_genre', String, method: :get do |genre_name|
      Song.all_by_genre(genre_name)
    end

    r.on 'unique_views' do
      r.post do
        current_date_time = DateTime.now
        params = r.params
        @unique_view = UniqueView.create(
          song_id: params['song_id'],
          user_id: params['user_id'],
          date: DateTime.now
        )
        @unique_view

      rescue Sequel::UniqueConstraintViolation # the user has already viewed.
        response.status = 400
        Error.message('User has already viewed')
      end

      r.on 'by_song_id', String, method: :get do |song_id|
        results = UniqueView.where(song_id: song_id)
        count = results.count
        user_ids = results.map { |result| result[:user_id] }.uniq

        {
          count: count,
          user_ids: user_ids
        }
      end 
    end

    r.on 'tags' do
      r.get do
        Tag.all
      end

      r.post do
        current_date_time = DateTime.now
        params = r.params
        @tag = Tag.create(
          value: params['value'],
          created_at: current_date_time
        )
        @tag

      rescue Sequel::UniqueConstraintViolation
        response.status = 400
        Error.message('Tag exists')
      end
    end

    r.on 'users' do
      r.post do

        params = r.params
        @user = User.create(
          username: params['username'],
          joined_on: DateTime.now
        )

        @user

      rescue Sequel::UniqueConstraintViolation
        response.status = 400
        Error.message('Username taken')
      end
    end

    r.on 'ratings' do
      r.post do
        current_date_time = DateTime.now
        params = r.params
        @rating = Rating.create(
          user_id: params['user_id'],
          song_id: params['song_id'],
          value: params['value'],
          created_at: current_date_time
        )

        @rating

      rescue Sequel::UniqueConstraintViolation
        response.status = 400
        Error.message('User already rated this song')
      rescue Sequel::CheckConstraintViolation => error
        if error.cause.to_s.include?("value_max_value")
          response.status = 400
          Error.message('Rating exceeds max value of 5')
        end
      end
    end
  end
end
