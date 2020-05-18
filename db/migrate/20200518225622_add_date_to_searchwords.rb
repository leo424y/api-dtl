class AddDateToSearchwords < ActiveRecord::Migration[6.0]
  def change
    add_column :searchwords, :start_date, :string
    add_index :searchwords, :start_date
    add_column :searchwords, :end_date, :string
    add_index :searchwords, :end_date
  end
end
