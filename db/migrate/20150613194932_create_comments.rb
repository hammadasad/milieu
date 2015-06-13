class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :user_id
      t.text :text
      t.integer :up_votes
      t.integer :down_votes
      t.integer :total_votes

      t.timestamps null: false
    end
  end
end
