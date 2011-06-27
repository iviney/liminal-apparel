class AddOrderCurrency < ActiveRecord::Migration
  def self.up
    add_column :orders, :currency, :string
  end

  def self.down
    remove_column :orders, :currency
  end
end
