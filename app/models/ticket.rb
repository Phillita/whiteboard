class Ticket < ActiveRecord::Base
  belongs_to :board
  belongs_to :column
  belongs_to :row
end
