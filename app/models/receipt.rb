class Receipt < ActiveRecord::Base
  belongs_to :group
  has_many :purchases
end
