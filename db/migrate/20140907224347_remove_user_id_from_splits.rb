class RemoveUserIdFromSplits < ActiveRecord::Migration
  def change
    remove_column :splits, :user_id
  end
end
