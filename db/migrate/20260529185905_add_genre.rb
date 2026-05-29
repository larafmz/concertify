class AddGenre < ActiveRecord::Migration[7.2]
  def change

     create_table :genres do |t|
      t.string :name
      t.timestamps
    end

    add_reference :artists, :genre
    
  end
end
