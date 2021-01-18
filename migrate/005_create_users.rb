Sequel.migration do
  up do
    create_table(:users) do
      primary_key :id
      String :username, null: false, unique: true
      String :display_name
      String :email
      String :login_source #google, facebook, etc
      Fixnum :song_limit, default: 25
      DateTime :joined_on, null: false, default: DateTime.now
      FalseClass :is_banned, default: false
      FalseClass :is_deactivated, default: false
    end
  end

  down do
    drop_table(:users)
  end
end
