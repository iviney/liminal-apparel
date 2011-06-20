class AddVolumePricingCurrencyPrices < ActiveRecord::Migration
  def self.up
    add_column :volume_prices, :currency_prices, :string
    remove_column :volume_prices, :price
  end

  def self.down
    remove_column :volume_prices, :currency_prices
    add_column :volume_prices, :price, :decimal, :precision => 8, :scale => 2
  end
end
