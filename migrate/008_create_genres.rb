Sequel.migration do
  up do
    create_table(:genres) do
      primary_key :id
      String :name
    end
  end

  down do
    drop_table(:genres)
  end
end
