Sequel.migration do
  up do
    create_table(:songs_tags) do
      primary_key :id
      foreign_key :song_id, :songs, type: Fixnum
      foreign_key :tag_id, :tags, type: Fixnum
    end
  end

  down do
    drop_table(:songs_tags)
  end
end
