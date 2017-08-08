class TyreQuantityConditional

  attr_reader :tyre_quantities

  def initialize(qty_hash)
    @tyre_quantities = countify(qty_hash)
  end

  def within_tolerance?
    outside_tolerance = tyre_quantities.each_with_object([]) do |count, level_one|
      count_type = count[:type]
      if count_type == 'shred' || count_type == 'scrap'
        level_one << count_type if weight_check(count_type, count[:qty])
      else
        level_one << count_type if qty_check(count_type, count[:qty])
      end
    end.compact
    outside_tolerance
  end

  private

  def qty_check(type, qty)
    qty > Tyre::QTY_CONDITIONALS[type.to_sym]
  end

  def weight_check(type, qty)
    ((qty < Tyre::QTY_CONDITIONALS[type.to_sym][:min]) || (qty > Tyre::QTY_CONDITIONALS[type.to_sym][:max])) && qty != 0
  end

  CollectionCount = Struct.new(:type, :qty)

  def countify(hash)
    hash.map {|cell| CollectionCount.new(cell[0].to_s.gsub('_qty', '').gsub('_weight', ''), cell[1].to_i)}
  end

end
