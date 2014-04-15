class AddStuffToLinks < ActiveRecord::Migration
  def change
    add_column :links, :full_name, :string
    add_column :links, :username, :string
  end
end
