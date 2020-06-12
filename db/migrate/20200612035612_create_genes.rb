class CreateGenes < ActiveRecord::Migration[6.0]
  def change
    create_table :genes do |t|
      t.string :media
      t.string :url
      t.string :title
      t.string :image
      t.string :tags
      t.string :create_time
      t.string :description
      t.timestamps
    end

    add_index :genes, :media
    add_index :genes, :url
    add_index :genes, :title
    add_index :genes, :create_time
  end
end
