class Report < ActiveRecord::Base



# TODO have all of these take in a date range
  def self.total_by_group_date(user, start_date, end_date)
    total_by_group = {}
    user.groups.each do |g|
      group_total = 0
      g.receipts.purchased_between(start_date, end_date).each do |r|
        puts r.title
        puts r.total.to_f
        group_total += r.total
        puts "group_total #{group_total}"
      end
      total_by_group[g] = group_total.to_f
    end
    total_by_group
  end

  def self.total_by_group(user)
    total_by_group = {}
    user.groups.each do |g|
      group_total = 0
      g.receipts.each do |r|
        puts r.title
        puts r.total.to_f
        group_total += r.total
        puts "group_total #{group_total}"
      end
      total_by_group[g] = group_total.to_f
    end
    total_by_group
  end

  def self.overall_total_for_user(user)
    total = 0
    self.total_by_group(user).each_value do |v|
      total += v
    end
    total.to_f
  end
end
