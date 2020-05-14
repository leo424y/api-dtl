class CreateFblinks < ActiveRecord::Migration[6.0]
  def change
    create_table :fblinks do |t|
      t.string :url
      t.string :link
      t.string :link_domain
      t.string :title
      t.string :date
      t.string :updated
      t.decimal :score
      t.timestamps
    end

    add_index :fblinks, :url
    add_index :fblinks, :link
    add_index :fblinks, :link_domain
    add_index :fblinks, :date
    add_index :fblinks, :updated
    add_index :fblinks, :score
  end
end
