class CreateReceipts < ActiveRecord::Migration
  def change
    create_table :receipts do |t|
      t.date :date
      t.string :title
      t.string :location
      t.decimal :total, :precision => 8, :scale => 2
      t.belongs_to :group

      t.timestamps
    end
  end
end
