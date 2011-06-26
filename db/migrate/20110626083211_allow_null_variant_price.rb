class AllowNullVariantPrice < ActiveRecord::Migration
  def self.up
    change_column :variants, :price, :decimal, :precision => 8, :scale => 2, :null => true
  end

  def self.down
    change_column :variants, :price, :decimal, :precision => 8, :scale => 2, :null => false
  end
end
