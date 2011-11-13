class CreateRetailers < ActiveRecord::Migration
  def self.up
    create_table :retailers do |t|
      t.string :name
      t.string :url
      t.string :country
      t.string :region
      t.string :category

      t.timestamps
    end
  end

  def self.down
    drop_table :retailers
  end
end
