class CreateColumns < ActiveRecord::Migration
  def change
    create_table :columns do |t|
      t.integer :board_id
      t.integer :order
      t.string :label

      t.timestamps
    end
  end
end
