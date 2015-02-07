class Group < ActiveRecord::Base
  has_many :memberships
  has_many :users, through: :memberships
  has_many :categories
  has_many :receipts
  has_many :purchases, through: :receipts

  # pass params from controller
  def total_by_date(start_date, end_date)
    total = 0.0
    # format dates
    self.receipts.purchased_between(start_date, end_date).each do |r|
      total += r.total
    end
    total
  end
  def total_by_category(start_date, end_date, category)
    # For receipts with date between start_date and end_date
    # For each category, calculate total %age of all purchases in that category and total spent on that category
    #View: Category - % - $


  end

  def total_by_member(start_date, end_date, membership_id)
    # For receipts with date between start_date and end_date
    # For all purchases, calculate total % and total spent by each member (using split %age)
    # View: Member name - % - $
  end

  def total_by_member_and_category(start_date, end_date, membership_id, category)
    # For receipts with date between start_date and end_date
    # For each category
    # receipts = scope date range
    # results = {}
    # memberships.each do |m|
    #   categories.each do |c|
    #       purchases.where("category_id = #{c.id} AND receipt_id IN #{receipt_ids}").each do |p|
  end

end
