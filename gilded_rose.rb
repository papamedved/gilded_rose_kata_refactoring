class GildedRose

  def initialize(items)
    @items = items
  end

  def update_quality()
    @items.each do |item|
      item.update
    end
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name 
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
  
  def update
    ItemUpdater.new(self).update
  end
  
end

class ItemUpdater
  attr_reader :item

  def initialize(item)
    @item = item
  end

  def update
    case item.name
      
      when 'Aged Brie'
        aged_update_quality
        aged_update_sell_in
      
      when 'Sulfuras, Hand of Ragnaros'
        sulfuras_update_quality
        sulfuras_update_sell_in
      
      when 'Backstage passes to a TAFKAL80ETC concert'
        backstage_update_quality
        backstage_update_sell_in
      else
        default_update_quality
        default_update_sell_in
      end
    
  end

  private

    def default_update_quality
      if item.sell_in > 0
        quality = item.quality - 1
      else
        quality = item.quality - 2
      end
  
      item.quality = quality if quality >= 0
    end
  
    def default_update_sell_in
      item.sell_in -= 1
    end
    
    def aged_update_quality
      if item.sell_in > 0
        quality = item.quality + 1
      else
        quality = item.quality + 2
      end

      item.quality = quality if quality <= 50
    end

    def aged_update_sell_in
      item.sell_in -= 1
    end
    
    def backstage_update_quality
      quality = if item.sell_in > 10
                  item.quality + 1
                elsif item.sell_in > 5
                  item.quality + 2
                elsif item.sell_in > 0
                  item.quality + 3
                else
                  0
                end

      item.quality = quality if quality <= 50
      item.quality = 50 if quality > 50
    end

    def backstage_update_sell_in
      item.sell_in -= 1
    end
    
    def sulfuras_update_quality
    end
    
    def sulfuras_update_sell_in
    end
end