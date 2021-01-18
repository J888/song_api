Sequel.migration do
  up do
    create_table(:genres_songs) do
      primary_key :id
      foreign_key :song_id, :songs, type: Fixnum
      foreign_key :genre_id, :genres, type: Fixnum
      unique [:genre_id, :song_id] # so that a song cannot be given the same genre twice
    end
  end

  down do
    drop_table(:genres_songs)
  end
end
