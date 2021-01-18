Sequel.migration do
  up do
    create_table(:unique_views) do
      primary_key :id
      foreign_key :song_id, :songs, type: Fixnum
      Fixnum :user_id, null: false
      unique [:user_id, :song_id] # so that user can't uniquely view same song twice

      DateTime :date, null: false, default: DateTime.now
    end
  end

  down do
    drop_table(:unique_views)
  end
end
