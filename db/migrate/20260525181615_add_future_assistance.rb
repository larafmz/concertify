class AddFutureAssistance < ActiveRecord::Migration[7.2]
  def change

     create_table :future_assistances do |t|
      t.references :user, null: false, foreign_key: true
      t.references :event, null: false, foreign_key: true
      t.integer :company
      t.string :from
      t.integer :event_seat
      t.string :event_seat_details
      t.references :interactuable, foreign_key: true
      t.timestamps
    end
    
  end
end
