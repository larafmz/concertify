class AddNotifications < ActiveRecord::Migration[7.2]
  def change

    create_table :notifications do |t|
      t.string :text
      t.date :date
      t.time :time
      t.boolean :opened
      t.references :notificable, polymorphic: true, null: false
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end    

  end
end
