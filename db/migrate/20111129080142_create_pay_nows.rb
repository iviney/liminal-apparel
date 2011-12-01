class CreatePayNows < ActiveRecord::Migration
  def self.up
    create_table :pay_nows do |t|
      t.integer :user_id, :null => false
      t.decimal :amount, :precision => 8, :scale => 2, :null => false
      t.string :currency, :limit => 20, :default => 'AUD', :null => false
      t.string :payment_state, :limit => 20, :default => 'unpaid'
      t.timestamps
    end
  end

  def self.down
    drop_table :pay_nows
  end
end
