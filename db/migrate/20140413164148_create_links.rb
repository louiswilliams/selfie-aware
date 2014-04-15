class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.integer :user_id
      t.string :link_id
      t.integer :score

      t.timestamps
    end
  end
end
