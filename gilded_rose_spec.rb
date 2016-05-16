require File.join(File.dirname(__FILE__), 'gilded_rose')

describe Item do
  describe 'to_s' do
    # shared_examples 'Вывод соотвествует шаблону' do |item|
    #   expect(item.to_s).to match(/^\w+, \d+, \d+$/)
    # end
    
    context 'Проверка вывода' do
      it 'Вывод соотвествует шаблону' do
        item = Item.new('foo', sell_in=0, quality=0)
        expect(item.to_s).to match(/^\w+, \d+, \d+$/)
      end
      
    end
  end
end

describe GildedRose do

  describe 'update_quality' do
    
    # Шаблоны
    
    shared_examples 'Товар по-умолчанию в продаже' do |item_name|
        it 'В конце дня уменьшаем продажу на 1' do
        item = Item.new(item_name, sell_in=1, quality=0)
        items = [item]
        gilded_rose = described_class.new(items)
        gilded_rose.update_quality

        expect(item.sell_in).to eq 0
      end

      it 'После N дней снижаем продажу на N' do
        n = 10
        item = Item.new(item_name, sell_in=n, quality=0)
        items = [item]
        gilded_rose = described_class.new(items)

        n.times do |i|
          gilded_rose.update_quality
          expect(item.sell_in).to eq (n - (i + 1))
        end

        expect(item.sell_in).to eq 0
      end

      
      it 'Продажа не должна быть отрицательной' do
        item = Item.new(item_name, sell_in=0, quality=0)
        items = [item]
        gilded_rose = described_class.new(items)
        gilded_rose.update_quality

        expect(item.sell_in).to eq -1
      end
    end

    # Товар foo
    
    context 'Наименование товара' do
      
      it 'Наименование не изменяется' do
        item = Item.new('foo', sell_in=0, quality=0)
        items = [item]
        gilded_rose = described_class.new(items)
        gilded_rose.update_quality

        expect(item.name).to eq 'foo'
      end
    end

    
    it_behaves_like 'Товар по-умолчанию в продаже', item_name='foo'

    context 'Качество товара' do
      
      item_name='foo'
      it 'Качество не должно быть отрицательным' do
        item = Item.new(item_name, sell_in=0, quality=0)
        items = [item]
        gilded_rose = described_class.new(items)
        gilded_rose.update_quality

        expect(item.quality).to eq 0
      end

      
      it 'Качество не должно быть больше 50' do
        item = Item.new(item_name, sell_in=20, quality=50)
        items = [item]
        gilded_rose = described_class.new(items)
        gilded_rose.update_quality

        expect(item.quality).to be <= 50
      end

      context 'Продажа в не наступившую дату' do
        
        it 'В конце дня уменьшаем качество на 1' do
          item = Item.new('foo', sell_in=1, quality=1)
          items = [item]
          gilded_rose = described_class.new(items)
          gilded_rose.update_quality

          expect(item.quality).to eq 0
        end

        
        it 'После N дней уменьшаем качество на N' do
          n = 10
          item = Item.new('foo', sell_in=n, quality=n)
          items = [item]
          gilded_rose = described_class.new(items)

          n.times do |i|
            gilded_rose.update_quality
            expect(item.quality).to eq (n - (i + 1))
          end

          expect(item.quality).to eq 0
        end
      end

      context 'Продажа в прошедшую дату' do
        
        it 'В конце дня уменьшаем качество на 2' do
          item = Item.new('foo', sell_in=0, quality=4)
          items = [item]
          gilded_rose = described_class.new(items)
          gilded_rose.update_quality

          expect(item.quality).to eq 2
        end

        
        it 'После N дней уменьшаем качество в 2 раза' do
          n = 5
          quality = 15
          item = Item.new('foo', sell_in=0, quality=quality)
          items = [item]
          gilded_rose = described_class.new(items)

          n.times do |i|
            gilded_rose.update_quality
            expect(item.quality).to eq (quality - (2 * (i+1)))
          end

          expect(item.quality).to eq (quality - (2 * n))
        end
      end
    end

    # Товар Aged Brie
    context 'Товар Aged Brie' do
      it_behaves_like 'Товар по-умолчанию в продаже', item_name='Aged Brie'

      context 'Качество товара' do
        context 'Продажа в не наступившую дату' do
          it 'По истечении времени увеличивается на 1' do
            n = 5
            item = Item.new('Aged Brie', sell_in=n, quality=0)
            items = [item]
            gilded_rose = described_class.new(items)

            n.times do |i|
              gilded_rose.update_quality
              expect(item.quality).to eq (i + 1)
            end

            expect(item.quality).to eq n
          end
        end

        context 'Продажа в прошедшую дату' do
          it 'По истичении увеличивается в 2 раза' do
            n = 5
            item = Item.new('Aged Brie', sell_in=0, quality=0)
            items = [item]
            gilded_rose = described_class.new(items)

            n.times do |i|
              gilded_rose.update_quality
              expect(item.quality).to eq (2 * (i + 1))
            end

            expect(item.quality).to eq (2 * n)
          end
        end

        it 'Не должно быть больше 50' do
          n = 2
          item = Item.new('Aged Brie', sell_in=n, quality=49)
          items = [item]
          gilded_rose = described_class.new(items)

          n.times do
            gilded_rose.update_quality
          end

          expect(item.quality).to eq 50
        end
      end
    end

    # ######################################################################
    # Sulfuras, Hand of Ragnaros
    # ######################################################################
    context 'Товар Sulfuras, Hand of Ragnaros' do
      context 'Товар по-умолчанию в продаже' do
        it 'Товар по-умолчанию в продаже' do
          item = Item.new('Sulfuras, Hand of Ragnaros', sell_in=0, quality=0)
          items = [item]
          gilded_rose = described_class.new(items)
          gilded_rose.update_quality

          expect(item.sell_in).to eql 0
        end
      end

      context 'Качество товара' do
        
        item_name='Sulfuras, Hand of Ragnaros'
        it 'Качество не должно быть отрицательным' do
        item = Item.new(item_name, sell_in=0, quality=0)
        items = [item]
        gilded_rose = described_class.new(items)
        gilded_rose.update_quality

        expect(item.quality).to eq 0
      end

      
      it 'Качество не должно быть больше 50' do
        item = Item.new(item_name, sell_in=20, quality=50)
        items = [item]
        gilded_rose = described_class.new(items)
        gilded_rose.update_quality

        expect(item.quality).to be <= 50
      end

        it 'Качество не изменяется' do
          item = Item.new('Sulfuras, Hand of Ragnaros', sell_in=0, quality=0)
          items = [item]
          gilded_rose = described_class.new(items)
          gilded_rose.update_quality

          expect(item.quality).to eql 0
        end
      end
    end

    # Backstage passes to a TAFKAL80ETC concert
    context 'Товар Backstage passes to a TAFKAL80ETC concert' do
      
      item_name='Backstage passes to a TAFKAL80ETC concert'
      context 'Качество товара' do
        
        item_name='Backstage passes to a TAFKAL80ETC concert'
        it 'Качество не должно быть отрицательным' do
        item = Item.new(item_name, sell_in=0, quality=0)
        items = [item]
        gilded_rose = described_class.new(items)
        gilded_rose.update_quality

        expect(item.quality).to eq 0
      end

      
      it 'Качество не должно быть больше 50' do
        item = Item.new(item_name, sell_in=20, quality=50)
        items = [item]
        gilded_rose = described_class.new(items)
        gilded_rose.update_quality

        expect(item.quality).to be <= 50
      end
        

        context 'Продажа в не наступившую дату' do
          context 'Продажа после 10 дней' do
            it 'По истечении времени увеличивается на 1' do
              n = 5
              quality = 1
              item = Item.new('Backstage passes to a TAFKAL80ETC concert', sell_in=15, quality=quality)
              items = [item]
              gilded_rose = described_class.new(items)

              n.times do |i|
                gilded_rose.update_quality
                expect(item.quality).to eq (quality + i + 1)
              end

              expect(item.quality).to eq (quality + n)
            end

            it 'Качество увеличивается с 49 до 50 при продаже свыше 10' do
              item = Item.new('Backstage passes to a TAFKAL80ETC concert', sell_in=15, quality=49)
              items = [item]
              gilded_rose = described_class.new(items)
              gilded_rose.update_quality

              expect(item.quality).to eq 50
            end

            it 'Качество увеличивается с 49 до 50 (вместо 51) при продаже 5' do
              item = Item.new('Backstage passes to a TAFKAL80ETC concert', sell_in=5, quality=49)
              items = [item]
              gilded_rose = described_class.new(items)
              gilded_rose.update_quality

              expect(item.quality).to eq 50
            end
          end

          context 'Продажа от 5 до 10 дней' do
            it 'По истечении времени увеличивается на 2' do
              n = 5
              quality = 1
              item = Item.new('Backstage passes to a TAFKAL80ETC concert', sell_in=10, quality=quality)
              items = [item]
              gilded_rose = described_class.new(items)

              n.times do |i|
                gilded_rose.update_quality
                expect(item.quality).to eq (quality + 2 * (i + 1))
              end

              expect(item.quality).to eq (quality + (2 * n))
            end

            it 'Качество увеличивается с  49 до 50 (вместо 52) при 1 продаже' do
              item = Item.new('Backstage passes to a TAFKAL80ETC concert', sell_in=1, quality=49)
              items = [item]
              gilded_rose = described_class.new(items)
              gilded_rose.update_quality

              expect(item.quality).to eq 50
            end
          end

          
          context 'Продажа в течение 5 дней' do
            
            it 'Увеличивается на 3 при умньшении даты' do
              n = 5
              quality = 1
              item = Item.new('Backstage passes to a TAFKAL80ETC concert', sell_in=5, quality=quality)
              items = [item]
              gilded_rose = described_class.new(items)

              n.times do |i|
                gilded_rose.update_quality
                expect(item.quality).to eq (quality + 3 * (i + 1))
              end

              expect(item.quality).to eq (quality + (3 * n))
            end

            it 'Качество увеличивается с 49 до 50 (вместо 52) при 1 продаже' do
              item = Item.new('Backstage passes to a TAFKAL80ETC concert', sell_in=1, quality=49)
              items = [item]
              gilded_rose = described_class.new(items)
              gilded_rose.update_quality

              expect(item.quality).to eq 50
            end
          end
        end

        
        context 'Продажа в прошедшую дату' do
          
          it 'Присваивается 0 после концерта' do
            item = Item.new('Backstage passes to a TAFKAL80ETC concert', sell_in=0, quality=5)
            items = [item]
            gilded_rose = described_class.new(items)
            gilded_rose.update_quality

            expect(item.quality).to eq 0
          end
        end
      end
    end
  end

end
