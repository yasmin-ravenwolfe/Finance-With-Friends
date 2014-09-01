class Group < ActiveRecord::Base
  has_many :memberships
  has_many :users, through: :memberships
  has_many :categories
  has_many :receipts
  has_many :purchases, through: :receipts
end
