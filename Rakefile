migrate = lambda do |env, version|
  ENV['RACK_ENV'] = env
  require_relative 'db'
  require 'logger'
  Sequel.extension :migration
  DB.loggers << Logger.new($stdout) if DB.loggers.empty?
  Sequel::Migrator.apply(DB, 'migrate', version)
end

desc "Migrate development database to latest version"
task :dev_up do
  migrate.call('development', nil)
end
task :dev_down do
  migrate.call('development', 0)
end

task :db_seed do
  require_relative 'db'
  require 'yaml'
  users = YAML.load(File.read("data/seed_data.yml"))['users']
  tags = YAML.load(File.read("data/seed_data.yml"))['tags']

  songs = YAML.load(File.read("data/seed_data.yml"))['songs']
  ratings = YAML.load(File.read("data/seed_data.yml"))['ratings']
  genres = YAML.load(File.read("data/seed_data.yml"))['genres']

  tags.each do |tag|
    DB[:tags].insert(
      value: tag['value']
    )
  end

  songs.each do |song|
    DB[:songs].insert(
      title: song['title'],
      artist: song['artist'],
      description: song['description'],
      image_url: song['image_url'],
      created_by_user_id: song['created_by_user_id']
    )
  end

  tags.size.times do |i|
    # generate tags for song 1
    DB[:songs_tags].insert(
      song_id: 1,
      tag_id: i + 1
    )

    # generate tags for song 2
    DB[:songs_tags].insert(
      song_id: 2,
      tag_id: i + 1
    )

    # generate tags for song 3
    DB[:songs_tags].insert(
      song_id: 3,
      tag_id: i + 1
    )

    # generate tags for song 4
    DB[:songs_tags].insert(
      song_id: 4,
      tag_id: i + 1
    )
  end

  users.each do |user|
    DB[:users].insert(
      username: user['username'],
      display_name: user['display_name'],
      email: user['email']
    )
  end

  ratings.each do |rating|
    DB[:ratings].insert(
      user_id: rating['user_id'],
      song_id: rating['song_id'],
      value: rating['value']
    )
  end

  genres.each do |genre|
    DB[:genres].insert(
      name: genre['name']
    )
  end

  genres.size.times do |i|
    # Genres for song 1
    DB[:genres_songs].insert(
      song_id: 1,
      genre_id: i +1
    )

    # Genres for song 2
    DB[:genres_songs].insert(
      song_id: 2,
      genre_id: i +1
    )
  end
end

task :db_reset_and_seed do

  Rake::Task["dev_down"].invoke
  Rake::Task["dev_up"].invoke
  Rake::Task["db_seed"].invoke
end
