class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.string :story
      t.string :pithy_tag
      t.string :description
      t.integer :requirements_points
      t.integer :development_points
      t.integer :board_id
      t.integer :column_id
      t.integer :row_id

      t.timestamps
    end
  end
end
