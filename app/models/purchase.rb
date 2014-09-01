class Purchase < ActiveRecord::Base
  belongs_to :receipt
  has_many :splits
end
