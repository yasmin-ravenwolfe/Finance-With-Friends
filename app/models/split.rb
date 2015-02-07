class Split < ActiveRecord::Base
  belongs_to :purchase

  validate :membership_id_if_percentage
  validates_numericality_of :percentage, less_than_or_equal_to: 1.00, message: "Percentage must be 100% or less."

  validates :membership_id, uniqueness: {scope: :purchase, message: "That person already has a split. Please edit their split if it is wrong."}

  # validate :percentage_total_100_or_less, on: :create

  # validate :update_percentage_total_100_or_less, on: :update

  # validates_exclusion_of :percentage, in: 0..0, message: "Can't assign 0% to a member."



  # YTF TODO: move these methods to Purchase.rb ? They are used to validate each split but splits belong to purchase

  # Don't need after implementing validate :percentage_total_100_or_less
  # def self.percentage_total_valid?(purchase, split)

  #   # return true if total_percentage <= 1.00
  #   if self.splits_total_percentage_by_purchase(purchase) <= 1.00
  #     true
  #   else
  #     split.errors.add(:percentage,  "total can't be more than 100%")
  #     false
  #   end
  # end

  def membership_id_if_percentage
    if (membership_id == nil && percentage.to_f == 0) || (membership_id == nil && percentage == nil)
      true
    elsif membership_id != nil && percentage == 0
      errors.add(:percentage, "Can't assign blank to a member")
      false
    elsif membership_id == nil && percentage != nil
      errors.add(:membership_id, "Can't assign a percentage without choosing a member.")
      false
     end
  end

  def self.percentage_total_equals_100?(purchase)
    return true if self.splits_total_percentage_by_purchase(purchase) == 100
  end
# Don't need to check if # of splits > members because of validation on uniqueness of member per purchase
  # def self.number_of_splits_equals_memberships(purchase, memberships)
  #   purchase.splits.to_a.size == memberships.size
  # end
  # def self.number_of_splits_valid?(purchase, split, memberships)
  #   if purchase.splits.size <=  memberships.size
  #     true
  #   else
  #     split.errors.add(:membership_id, "Can't have more splits than group members.")
  #     false
  #   end
  # end

  def self.splits_total_percentage_by_purchase(purchase)
    total_percentage = 0
    Split.where(purchase_id: purchase.id).each do |s|
      total_percentage += s.percentage.to_f
    end
    total_percentage.to_f * 100
  end

  # def percentage_total_100_or_less
  #   total_percentage = self.percentage.to_f
  #   puts "\n\n ytf total per before #{total_percentage}"
  #   raise self.purchase_id.inspect
  #   Split.where(purchase_id: self.purchase_id).each do |s|
  #     raise s.id.inspect
  #       total_percentage += s.percentage.to_f
  #   end
  #    puts "\n\n ytf total at end #{total_percentage}"
  #   unless total_percentage.to_f <= 1.00
  #     self.errors.add(:percentage,  "total can't be more than 100%")
  #     false
  #   end
  # end

  def update_percentage_total_100_or_less
    total_percentage = self.percentage.to_f

    old_split = Split.where(id: self.id)
    splits_to_total = Split.where(purchase_id: self.purchase_id).reject { |i| i == self }

    splits_to_total.each do |s|
        total_percentage += s.percentage.to_f
    end

    unless total_percentage.to_f <= 1.00
      self.errors.add(:percentage,  "total can't be more than 100%")
      false
    end
  end
end
