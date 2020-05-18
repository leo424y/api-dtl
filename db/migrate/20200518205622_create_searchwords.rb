class CreateSearchwords < ActiveRecord::Migration[6.0]
  def change
    create_table :searchwords do |t|
      t.string :word
      t.timestamps
    end

    add_index :searchwords, :word
  end
end
