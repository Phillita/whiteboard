class Board < ActiveRecord::Base
	has_many :columns, :dependent => :destroy
  has_many :rows, :dependent => :destroy
	has_many :tickets
	
	accepts_nested_attributes_for :columns, :reject_if => lambda { |a| a[:label].blank? }, :allow_destroy => true
	accepts_nested_attributes_for :rows, :reject_if => lambda { |a| a[:label].blank? }, :allow_destroy => true
end
