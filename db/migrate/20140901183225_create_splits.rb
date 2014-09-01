class CreateSplits < ActiveRecord::Migration
  def change
    create_table :splits do |t|
      t.belongs_to :purchase
      t.integer :membership_id
      t.decimal :percentage, :precision => 7, :scale => 4
      t.timestamps
    end
  end
end
