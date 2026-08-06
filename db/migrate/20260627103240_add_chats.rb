class AddChats < ActiveRecord::Migration[7.2]
  def change

    create_table :chats do |t|
      t.references :event
      t.timestamps
    end    

    create_table :chat_entries do |t|
      t.string :text
      t.references :chat
      t.references :user
      t.integer :chat_type
      t.references :message_father, foreign_key: { to_table: :chat_entries }
      t.timestamps
    end    

    create_table :chat_users do |t|
      t.references :user, null: false, foreign_key: true
      t.references :chat, null: false, foreign_key: true
      t.datetime :read_at
      t.timestamps 
    end

    add_index :chat_users, [:user_id, :chat_id], unique: true

  end
end
