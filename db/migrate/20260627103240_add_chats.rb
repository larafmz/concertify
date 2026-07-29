class AddChats < ActiveRecord::Migration[7.2]
  def change

    create_table :chats do |t|
      t.references :event
      t.timestamps
    end    

    create_table :messages do |t|
      t.string :text
      t.references :chat
      t.references :user
      t.references :message_father, foreign_key: { to_table: :messages }
      t.timestamps
    end    

    create_table :chat_users do |t|
      t.references :user, null: false, foreign_key: true
      t.references :chat, null: false, foreign_key: true
      t.timestamps 
    end

  end
end
