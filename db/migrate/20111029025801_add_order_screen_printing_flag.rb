class AddOrderScreenPrintingFlag < ActiveRecord::Migration
  def self.up
    add_column :orders, :screen_printing, :boolean
  end

  def self.down
  end
end
