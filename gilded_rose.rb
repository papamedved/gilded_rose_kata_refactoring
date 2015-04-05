
def item_quality_up(item, value)
  item.quality += value
end

def item_quality_down(item, value)
  item.quality -= value
end

def item_sell_in_down(item, value)
  item.sell_in -= value
end

def update_quality(items)
  items.each do |item|

    case item.name

      when 'NORMAL ITEM'
        item_sell_in_down(item, 1)
        item_quality_down(item, 1) if item.quality > 0
        item_quality_down(item, 1) if item.sell_in < 0

      when 'Aged Brie'
        item_sell_in_down(item, 1)
        item_quality_up(item, 1) if item.quality < 11
        item_quality_up(item, 1) if item.quality < 50 && item.sell_in < 0

      when 'Backstage passes to a TAFKAL80ETC concert'
        item_quality_up(item, 1) if item.quality < 50
        item_quality_up(item, 1) if item.quality < 50 && item.sell_in < 11
        item_quality_up(item, 1) if item.quality < 50 && item.sell_in < 6
        item_sell_in_down(item, 1)
        item_quality_down(item, item.quality) if item.sell_in < 0

      when 'Conjured Mana Cake'
        item_sell_in_down(item, 1)
        item_quality_down(item, 2) if item.quality != 0 && item.sell_in > 0
        item_quality_down(item, 4) if item.quality != 0 && item.sell_in <= 0

    end
  end
end

# DO NOT CHANGE THINGS BELOW -----------------------------------------

Item = Struct.new(:name, :sell_in, :quality)

# We use the setup in the spec rather than the following for testing.
#
# Items = [
#   Item.new("+5 Dexterity Vest", 10, 20),
#   Item.new("Aged Brie", 2, 0),
#   Item.new("Elixir of the Mongoose", 5, 7),
#   Item.new("Sulfuras, Hand of Ragnaros", 0, 80),
#   Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 20),
#   Item.new("Conjured Mana Cake", 3, 6),
# ]
