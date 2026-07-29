class AddArtistAndEvent < ActiveRecord::Migration[7.2]
  def change
    
    create_table :artists do |t|
      t.string :name
      t.string :ticketmaster_id
      t.integer :status
      t.references :requester, foreign_key: { to_table: :users }
      t.timestamps
    end

    create_table :events do |t|
      t.string :ticketmaster_id
      t.string :tour_name
      t.date :date
      t.datetime :start_time
      t.integer :status
      t.references :requester, foreign_key: { to_table: :users }
      t.timestamps
    end

  end
end
