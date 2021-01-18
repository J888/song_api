Sequel.migration do
  up do
    create_table(:users_songs) do
      primary_key :id
      foreign_key :user_id, :users, type: Fixnum
      foreign_key :song_id, :songs, type: Fixnum
    end
  end

  down do
    drop_table(:users_songs)
  end
end
