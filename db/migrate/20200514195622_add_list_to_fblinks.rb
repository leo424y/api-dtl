class AddListToFblinks < ActiveRecord::Migration[6.0]
  def change
    add_column :fblinks, :list, :string
    add_index :fblinks, :list
  end
end
