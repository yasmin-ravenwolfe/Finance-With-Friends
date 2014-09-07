module ApplicationHelper

  def splits_equal_100?(purchase)
    total_percentage = 0
    purchase.splits.each do |s|
      total_percentage += s.percentage.to_f
    end
      return true if total_percentage.to_f == 1.00
  end
end
