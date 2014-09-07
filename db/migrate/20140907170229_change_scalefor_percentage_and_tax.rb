class ChangeScaleforPercentageAndTax < ActiveRecord::Migration
  def change
    change_column :splits, :percentage, :decimal, precision: 5, scale: 4
    change_column :purchases, :tax, :decimal, precision: 5, scale: 4
  end
end
