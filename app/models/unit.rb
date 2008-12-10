class Unit < ActiveRecord::Base
  validates_numericality_of :scale, :greater_than => 0
end
