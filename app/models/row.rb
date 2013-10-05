class Row < ActiveRecord::Base
	belongs_to :board

  before_save :add_sequential_order

  def add_sequential_order
    self.order = self.board.rows.count + 1
  end
end
