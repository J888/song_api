Sequel.migration do
  up do
    create_table(:ratings) do
      primary_key :id

      foreign_key :user_id, :users, type: Fixnum
      foreign_key :song_id, :songs, type: Fixnum
      unique [:user_id, :song_id] # so that user can't rate same song twice
      
      DateTime :created_at, null: false, default: DateTime.now

      Fixnum :value, null: false
      constraint(:value_max_value){ value <= 5}
    end
  end

  down do
    drop_table(:ratings)
  end
end
