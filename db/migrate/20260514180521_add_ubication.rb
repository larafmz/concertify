class AddUbication < ActiveRecord::Migration[7.2]
  def change

    create_table :countries do |t|
      t.string :name
      t.string :code
      t.timestamps
    end

    create_table :ubications do |t|
      t.string :city
      t.string :state
      t.string :venue
      t.references :country, foreign_key: { on_delete: :cascade }
      t.references :user
      t.timestamps
    end

    add_reference :events, :ubication

  end
end
