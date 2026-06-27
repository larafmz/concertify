class AddRelations < ActiveRecord::Migration[7.2]
  def change

    create_table :relations do |t|
      t.references :follower, foreign_key: { to_table: :users }
      t.references :followed, polymorphic: true, null: false
      t.integer :relation_type
      t.timestamps
    end    

  end
end
