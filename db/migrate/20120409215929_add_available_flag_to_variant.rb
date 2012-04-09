class AddAvailableFlagToVariant < ActiveRecord::Migration
  def self.up
    add_column :variants, :available, :boolean, :default => true
  end

  def self.down
    remove_column :variants, :available
  end
end
