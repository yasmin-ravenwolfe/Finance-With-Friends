# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

yasmin = User.create(name: "Yasmin", email: "yfazelinia@gmail.com", password: "password")
frank = User.create(name: "Frank", email: "frank@frank.com", password: "password")

y_group = Group.create(name: "Yasmin's Group", balance: 0)
health = y_group.categories.create(title: "Health")

yf_group = Group.create(name: "Yasmin-Frank Group", balance: 0)
groceries = y_group.categories.create(title: "Groceries")

# Create a membership for user Yasmin, group Yasmin
yasmin_y_group_mem = y_group.memberships.create(user_id: yasmin.id)
# Create a membership for Yasmin, group Yasmin-Frank
yasmin_yf_group_mem = yf_group.memberships.create(user_id: yasmin.id)
# Create a membership for Frank, group Yasmin-Frank
frank_yf_group_mem = yf_group.memberships.create(user_id: frank.id)

# After logging into a specific group (@current_group = group chosen), create a receipt
# Set @current_group = current_user.y_group  b/c chose "y_group" from menu
y_receipt_one = y_group.receipts.create(title: "Yoga-Sept", date:"09/01/2014", location: "Bikram Yoga San Jose")

# current_user is yasmin
# @current_group.receipts.title = "Yoga-Sept"
# After creating receipt, click "Add Purchase"
  # Or receipt(params[:id]) to find current receipt
# If group.memberships == 1, set percentage = false 
y_purchase_one = y_receipt_one.purchases.create(description: "One month of unlimited yoga", category_id: health.id, price: 100, quantity: 1, tax: 0.075, split: false)
y_purchase_one.taxed_total = y_purchase_one.price + (y_purchase_one.price * y_purchase_one.tax)
y_purchase_one.save

# Receipt total
y_group.receipts.each do |r|
  r.total = 0
  r.purchases.each do |p|
    r.total += p.taxed_total
  end
  r.save
end
# Membership and group balance for one member group
g_and_m_total = 0 
y_group.receipts.each do |r|
  g_and_m_total += r.total
end
puts "gandm #{g_and_m_total}"
yasmin_y_group_mem.balance = g_and_m_total
yasmin_y_group_mem.save
puts "mem bal #{yasmin_y_group_mem.balance}"
y_group.balance = g_and_m_total
y_group.save



# y_purchase_one_split = y_purchase_one.splits.create({membership_id: yasmin_y_group_mem.id, percentage: 100})

# @current_group = yfgroup  
  # current_user could be Yasmin or Frank
# @current_group.receipts.title = "Trader Joe's-Sept" 
yf_receipt_one = yf_group.receipts.create(title: "Trader Joe's-Sept", date:"09/01/2014", location: "Trader Joe's")
yf_purchase_one = yf_receipt_one.purchases.create(description: "Bananas", category_id: groceries.id, price: 2.00, quantity: 1, tax: 0, split: true)
if yf_purchase_one.tax == 0 
  yf_purchase_one.taxed_total = yf_purchase_one.price
  yf_purchase_one.save
end

yf_purchase_one_split_one = yf_purchase_one.splits.create(membership_id: yasmin_yf_group_mem.id, percentage: 0.50)
yf_purchase_one_split_two = yf_purchase_one.splits.create(membership_id: frank_yf_group_mem.id, percentage: 0.50)
# Membership balace, use method below for groups with more than 1 user 
yasmin_yf_group_mem.balance = yf_purchase_one_split_one.percentage * yf_purchase_one.taxed_total
yasmin_yf_group_mem.save
frank_yf_group_mem.balance = yf_purchase_one_split_two.percentage * yf_purchase_one.taxed_total
frank_yf_group_mem.save

# Receipt total
yf_group.receipts.each do |r|
  r.total = 0
  r.purchases.each do |p|
    r.total += p.taxed_total
  end
  r.save
end
# YF group balance
yf_group_balance = 0
yf_group.memberships.each do |m|
  yf_group_balance += m.balance
end
yf_group.balance = yf_group_balance
yf_group.save

# def receipt_total_by_member(group, membership, receipt)
#   user_total = 0
#   if group.memberships.size == 1
#     receipt.purchases.each do |p|
#       user_total += p.taxed_total
#     end
#   else
#    receipt.purchases.each do |p|
#     split = p.splits.where({membership_id: membership.id}).percentage
#     user_total += split * p.taxed_total
#     end
#   end
#   user_total
# end



# @current_group = membership.groups.where(group_id: params[:id])
# @current_group.purchase.percentage








