class CreatePayments < ActiveRecord::Migration
  def self.up
    create_table :payments do |t|
      t.integer :invoice_id
      t.decimal :amount
      t.string :name
      t.string :email
      t.string :charge_id
      t.integer :payment_id
      
      t.timestamps
    end
  end

  def self.down
    drop_table :payments
  end
end
