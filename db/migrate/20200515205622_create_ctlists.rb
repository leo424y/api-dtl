class CreateCtlists < ActiveRecord::Migration[6.0]
  def change
    create_table :ctlists do |t|
      t.string :listid
      t.string :creator
      t.timestamps
    end

    add_index :ctlists, :listid
    add_index :ctlists, :creator
  end
end
