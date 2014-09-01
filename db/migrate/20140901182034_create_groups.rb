class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.decimal :balance, :precision => 8, :scale => 2
      t.timestamps
    end
  end
end
