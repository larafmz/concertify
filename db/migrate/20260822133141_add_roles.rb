class AddRoles < ActiveRecord::Migration[7.2]
  def change

    create_table :roles do |t|
      t.string :name, index: true
      t.timestamps
    end

    add_reference :users, :role

  end
end
