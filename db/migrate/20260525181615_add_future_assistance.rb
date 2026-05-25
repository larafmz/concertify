class AddFutureAssistance < ActiveRecord::Migration[7.2]
  def change

     create_table :future_assistances do |t|
      t.references :user, null: false, foreign_key: true
      t.references :concert, null: false, foreign_key: true
      t.boolean :alone
      t.string :from
      t.integer :concert_seat
      t.string :concert_seat_details
      t.references :interactuable, foreign_key: true
      t.timestamps
    end
    
  end
end
