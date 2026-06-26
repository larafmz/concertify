class AddUserAttributes < ActiveRecord::Migration[7.2]
  def change

    add_column :users, :username, :string
    add_column :users, :name, :string
    add_column :users, :description, :string

  end
end
