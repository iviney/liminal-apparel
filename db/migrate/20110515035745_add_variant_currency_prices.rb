class AddVariantCurrencyPrices < ActiveRecord::Migration
  def self.up
    add_column :variants, :currency_prices, :string
  end

  def self.down
    remove_column :variants, :currency_prices
  end
end
