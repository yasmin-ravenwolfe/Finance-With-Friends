class Purchase < ActiveRecord::Base
  belongs_to :receipt
  has_many :splits

  attr_accessor :membership_id_split, :membership_id_one_buyer, :percentage

  after_save :update_balance_by_adding_purchase

# before_destory? will record be there for associated classes after destroy?
  # after_destroy :update_balance_by_subtracting_purchase


  def update_balance_by_adding_purchase
    receipt = self.receipt
    group = receipt.group
    # membership = Membership.where(group_id: group.id)

    receipt.total += self.taxed_total
    receipt.save

    group.balance += self.taxed_total
    group.save

    # Deal with splits as a after_save for Split class
    # unless self.split
    #   membership.balance += self.taxed_total
    # end
  end

  # def update_balance_by_subtracting_purchase
  #   receipt = self.receipt
  #   group = receipt.group
  #   membership = Membership.where(group_id: group.id).first

  #   receipt.total -= self.taxed_total
  #   receipt.save

  #   group.balance -= self.taxed_total
  #   group.save

  #   if self.split
  #     membership.balance -= self.taxed_total
  #   end
  # end

end
