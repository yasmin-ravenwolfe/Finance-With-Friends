class SetDefaultValuesAsZero < ActiveRecord::Migration
  def change
    change_column :groups, :balance, :decimal, precision: 8, scale: 2, default: 0
    change_column :memberships, :balance, :decimal, precision: 8, scale: 2, default: 0
    change_column :receipts, :total, :decimal, precision: 8, scale: 2, default: 0
    change_column :purchases, :taxed_total, :decimal, precision: 8, scale: 2, default: 0
  end
end
