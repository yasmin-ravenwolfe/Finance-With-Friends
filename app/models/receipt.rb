class Receipt < ActiveRecord::Base
  belongs_to :group
  has_many :purchases

  scope :purchased_between, lambda {|start_date, end_date| where("date >= ? AND date <= ?", start_date, end_date )}
end
