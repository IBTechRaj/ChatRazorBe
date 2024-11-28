class CreatePayments < ActiveRecord::Migration[7.1]
  def change
    create_table :payments do |t|
      t.string :order_id
      t.integer :amount
      t.string :currency
      t.string :payment_status
      t.string :razorpay_payment_id

      t.timestamps
    end
  end
end
