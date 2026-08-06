class AddUserAttributes < ActiveRecord::Migration[7.2]
  def change

    add_column :users, :username, :string
    add_column :users, :description, :string
    add_column :users, :open_chat_id, :integer

  end
end
