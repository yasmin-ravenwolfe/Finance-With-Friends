class Category < ActiveRecord::Base
  belongs_to :group

  validates :title, presence: true

  after_destroy :remove_categories_from_purchases

  def remove_categories_from_purchases
    purchases = Purchase.where(category_id: self.id)
    purchases.each do |p|
      p.category_id = nil
      p.save
    end
  end
end
