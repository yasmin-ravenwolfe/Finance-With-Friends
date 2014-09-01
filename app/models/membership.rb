class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :group

  # attr_accessor :balance
end
