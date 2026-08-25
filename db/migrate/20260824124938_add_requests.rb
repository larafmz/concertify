class AddRequests < ActiveRecord::Migration[7.2]
  def change

    create_table :requests do |t|
      t.integer :status
      t.string :message
      t.bigint :existing_event_id
      t.references :requester, foreign_key: { to_table: :users }
      t.timestamps
    end

    add_reference :events, :request
    add_reference :artists, :request

  end
end
