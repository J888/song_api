Sequel.migration do
  up do
    create_table(:songs) do
      primary_key :id
      String :title, null: false
      String :artist, null: false
      String :description
      String :main_play_url
      String :where_to_find # e.g. Spotify, Soundcloud, TikTok, Instagram
      String :hook_lyrics
      String :artist_contact
      String :image_url
      Fixnum :created_by_user_id, null: false
      DateTime :created_at, null: false, default: DateTime.now
      DateTime :updated_at, null: false, default: DateTime.now
      FalseClass :is_marked_for_delete, default: false
      FalseClass :is_banned, default: false
    end
  end

  down do
    drop_table(:songs)
  end
end
