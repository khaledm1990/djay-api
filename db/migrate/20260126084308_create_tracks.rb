class CreateTracks < ActiveRecord::Migration[8.1]
  def change
    create_table :tracks do |t|
      t.string :name, null: false
      t.references :artist, null: false, foreign_key: true

      t.timestamps
    end
  end
end
