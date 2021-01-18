Sequel.migration do
  up do
    create_table(:unique_views) do
      primary_key :id
      foreign_key :song_id, :songs, type: Fixnum
      Fixnum :user_id, null: false, unique: true
      DateTime :date, null: false
    end
  end

  down do
    drop_table(:unique_views)
  end
end
