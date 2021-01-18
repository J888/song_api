Sequel.migration do
  up do
    create_table(:tags) do
      primary_key :id
      String :value, null: false, unique: true
      DateTime :created_at, null: false, default: DateTime.now
    end
  end

  down do
    drop_table(:tags)
  end
end
