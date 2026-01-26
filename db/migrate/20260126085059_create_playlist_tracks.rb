class CreatePlaylistTracks < ActiveRecord::Migration[8.1]
  def change
    create_table :playlist_tracks do |t|
      t.references :playlist, null: false, foreign_key: true
      t.references :track, null: false, foreign_key: true

      t.index [ :playlist_id, :track_id ], unique: true
      t.timestamps
    end
  end
end
