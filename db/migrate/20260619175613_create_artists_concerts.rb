class CreateArtistsConcerts < ActiveRecord::Migration[7.2]
  def change
    create_table :artists_concerts do |t|
      t.references :artist, null: false, foreign_key: true
      t.references :concert, null: false, foreign_key: true      
      t.timestamps
    end

    add_index :artists_concerts, [:artist_id, :concert_id], unique: true
  end
end
