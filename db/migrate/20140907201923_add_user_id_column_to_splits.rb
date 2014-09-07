class AddUserIdColumnToSplits < ActiveRecord::Migration
  def change
    add_column :splits, :user_id, :integer
  end
end
