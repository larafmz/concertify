class AddInteractuable < ActiveRecord::Migration[7.2]
  def change
    
     create_table :interactuables do |t|
      t.string :type  
      t.references :user, null: false, foreign_key: true
      t.string :review

      # atributos de publicación
      t.references :artist
      t.references :concert
      #t.references :future_assistance TO/DO
      
      # atributos de concierto registrado
      t.integer :rating

      t.timestamps
    end

  end
end

