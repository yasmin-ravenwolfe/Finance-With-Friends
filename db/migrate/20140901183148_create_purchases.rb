class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.string :description
      t.integer :category_id
      t.decimal :price, :precision => 8, :scale => 2
      t.integer :quantity
      t.decimal :tax, :precision => 7, :scale => 4
      t.boolean :split
      t.decimal :taxed_total, :precision => 8, :scale => 2
      t.belongs_to :receipt

      t.timestamps
    end
  end
end
