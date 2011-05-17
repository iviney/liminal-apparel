class AddAddressCompanyName < ActiveRecord::Migration
  def self.up
    add_column :addresses, :company_name, :string
  end

  def self.down
    remove_column :addresses, :company_name
  end
end
