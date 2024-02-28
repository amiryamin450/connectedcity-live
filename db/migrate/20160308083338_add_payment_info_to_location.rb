class AddPaymentInfoToLocation < ActiveRecord::Migration[7.0]
  def change
    change_table :locations do |t|
      t.integer :payment_user_id
      t.string :stripe_plan_id
      t.string :stripe_subscription_id
    end
  end
end
