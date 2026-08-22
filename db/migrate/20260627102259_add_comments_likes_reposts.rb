class AddCommentsLikesReposts < ActiveRecord::Migration[7.2]
  def change

    create_table :comments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :interactuable, null: false, foreign_key: true
      t.string :text
      t.references :comment_father, foreign_key: { to_table: :comments }
      t.timestamps
    end

    create_table :likes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :interactuable, null: false, foreign_key: true
      t.timestamps
    end
    
    create_table :reposts do |t|
      t.references :user, null: false, foreign_key: true
      t.references :interactuable, null: false, foreign_key: true
      t.timestamps
    end    

  end
end
