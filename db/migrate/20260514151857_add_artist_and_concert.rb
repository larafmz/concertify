class AddArtistAndConcert < ActiveRecord::Migration[7.2]
  def change
    
    create_table :artists do |t|
      t.string :name
      t.string :ticketmaster_id
      t.timestamps
    end

    create_table :concerts do |t|
      t.string :ticketmaster_id
      t.string :tour_name
      t.date :date
      t.time :start_time
      t.time :end_time
      t.references :artist, foreign_key: { on_delete: :cascade }
      t.timestamps
    end

  end
end
