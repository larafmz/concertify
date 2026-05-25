class AddTaggedUser < ActiveRecord::Migration[7.2]
  def change
    
     create_table :tagged_users do |t|
      t.references :user, null: false, foreign_key: true
      t.references :interactuable, null: false, foreign_key: true
      t.timestamps 
    end

  end
end
