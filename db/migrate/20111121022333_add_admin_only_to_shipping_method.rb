class AddAdminOnlyToShippingMethod < ActiveRecord::Migration
  def self.up
    add_column :shipping_methods, :admin_only, :boolean
  end

  def self.down
    remove_column :shipping_methods, :admin_only
  end
end
