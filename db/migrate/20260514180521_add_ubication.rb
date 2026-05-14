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
      t.string :address
      t.references :country, foreign_key: { on_delete: :cascade }
      t.timestamps
    end

    add_reference :concerts, :ubication

  end
end
