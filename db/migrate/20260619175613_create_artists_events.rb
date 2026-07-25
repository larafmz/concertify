class CreateArtistsEvents < ActiveRecord::Migration[7.2]
  def change
    create_table :artists_events do |t|
      t.references :artist, null: false, foreign_key: true
      t.references :event, null: false, foreign_key: true      
      t.timestamps
    end

    add_index :artists_events, [:artist_id, :event_id], unique: true
  end
end
