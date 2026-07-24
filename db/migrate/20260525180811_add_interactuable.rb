class AddInteractuable < ActiveRecord::Migration[7.2]
  def change
    
     create_table :interactuables do |t|
      t.string :type  
      t.references :user, null: false, foreign_key: true
      t.string :review
      t.references :artist
      t.references :concert
      t.integer :rating
      t.timestamps
    end

  end
end

