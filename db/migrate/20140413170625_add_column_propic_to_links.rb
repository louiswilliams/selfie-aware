class AddColumnPropicToLinks < ActiveRecord::Migration
  def change
    add_column :links, :propic, :string
  end
end
