class AddPlatformToFblinks < ActiveRecord::Migration[6.0]
  def change
    add_column :fblinks, :platform_id, :string
    add_index :fblinks, :platform_id
    add_column :fblinks, :platform_name, :string
    add_index :fblinks, :platform_name
  end
end
