class Merchant <ApplicationRecord
  has_many :items

  validates_presence_of :name,
                        :address,
                        :city,
                        :state,
                        :zip

  def sold_items?
    merchants = OrderItem.all.pluck(:merchant_id)
    merchants.include?(self.id)
    #use more ActiveRecord on refactor - joins tables together to see if they're empty or not
  end

  def count_of_items
    items.count
  end

  def average_price
    items.average(:price)
  end

  def distinct_cities
    items.joins(:orders).order("orders.city").distinct.pluck("orders.city")
  end

  def top_3_items
    hash = Hash.new(0)
    avg_rtg_array = items.each do |item|
                      hash[item.name] = item.average_rating
                    end
    sorted_hash = hash.sort_by { |name, avg_rtg| avg_rtg }
    sorted_hash.last(3)
  end

end
