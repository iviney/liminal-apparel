class AddVolumePricingCurrencyPrices < ActiveRecord::Migration
  def self.up
    add_column :volume_prices, :currency_prices, :string
    
    # There is index name length error raised by SQLite when removing the price column while this index is present
    remove_index :volume_prices, [:variant_id, :starting_quantity]
    remove_column :volume_prices, :price
    add_index :volume_prices, [:variant_id, :starting_quantity], :unique => true
  end

  def self.down
    remove_index :volume_prices, [:variant_id, :starting_quantity]
    remove_column :volume_prices, :currency_prices
    add_index :volume_prices, [:variant_id, :starting_quantity], :unique => true
    
    add_column :volume_prices, :price, :decimal, :precision => 8, :scale => 2
  end
end
