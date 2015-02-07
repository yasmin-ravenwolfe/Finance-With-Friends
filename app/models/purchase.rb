class Purchase < ActiveRecord::Base
  belongs_to :receipt
  has_many :splits

  accepts_nested_attributes_for :splits
  attr_accessor :membership_id_one_buyer

  before_save :calculate_taxed_total
  after_save :update_receipt_balance, :update_group_balance, :update_membership_balance
  after_destroy :update_receipt_balance, :update_group_balance, :update_membership_balance

  ## ???? Faster to total up each after save or just subtract old self and then update balance by just adding new self
  ## Only add new totals after_create (not after_save), so updated totals won't added without subtracting old split from balance first.
  # after_create :add_new_splits_to_membership_balance, :add_new_purchase_to_receipt_and_group_balances

  ## Remove old total from balance before_update, while it still exists.
  # before_update :remove_old_splits_from_membership_balance, :remove_old
  # after_update :update_membership_balance
  ## before_destroy? will record be there for associated classes after destroy?
  # after_destroy :update_balance_by_subtracting_purchase


  # Since splits are on same form as purchase, calling this callback in Split.rb only is triggered if Splits are changed, not if purchase price/quantity is. Here, regardless of if splits are edited or not, membership balance is updated.
  def update_membership_balance
    self.splits.each do |split|
      membership = Membership.where(id: split.membership_id).first
      membership_balance = 0
      Split.where(membership_id: split.membership_id).each do |s|
        membership_balance += s.purchase.taxed_total * s.percentage
      end
      membership.update_attributes(balance: membership_balance)
    end
  end

  def calculate_taxed_total
    sub_total = self.price * self.quantity
    taxed_total = (self.tax * sub_total) + sub_total

    self.taxed_total = taxed_total
  end

  def update_receipt_balance
    receipt = self.receipt

    receipt_total = 0.0
    Purchase.where(receipt_id: receipt.id).each do |p|
      puts receipt_total
      puts p.taxed_total
      receipt_total += p.taxed_total
    end
    receipt.update(total: receipt_total)
  end

  def update_group_balance
    group = self.receipt.group

    group_balance = 0.0
    Receipt.where(group_id: group.id).each do |r|
      group_balance += r.total
    end
    group.update(balance: group_balance)
  end

  # def add_new_purchase_to_receipt_and_group_balances
  #   receipt = self.receipt
  #   group = receipt.group

  #   receipt.update(total: receipt.total += self.taxed_total)
  #   group.update(balance: group.balance += self.taxed_total)
  # end

  # def remove_old_splits_from_membership_balance
  #   self.splits.each do |s|
  #     membership = Membership.where(id: s.membership_id)
  #     balance_without_old_split = membership.balance - self.taxed_total * s.percentage
  #     membership.update(balance: balance_without_old_split)
  #   end
  # end

  # def update_membership_balance
  #   self.splits.each do |s|
  #       membership = Membership.where(id: s.membership_id)
  #       new_balance = membership.balance + self.taxed_total * s.percentage
  #       membership.update(balance: new_balance)
  #   end
  # end

  # def add_new_splits_to_membership_balance
  #   self.splits.each do |s|
  #       membership = Membership.where(id: s.membership_id)
  #       balance = self.taxed_total * s.percentage
  #       membership.update(balance: balance)
  #   end
  # end

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
