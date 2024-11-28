require 'razorpay'

class Api::V1::PaymentsController < ApplicationController
  require 'razorpay'

class Api::V1::PaymentsController < ApplicationController
  def create
    Razorpay.setup(ENV['RAZORPAY_KEY_ID'], ENV['RAZORPAY_KEY_SECRET'])

    # payment_amount = params[:amount] * 100 # Razorpay expects amount in paise
    payment_amount = (params[:amount].to_f * 100).to_i

    # Create an order on Razorpay's side
    order = Razorpay::Order.create({
      amount: payment_amount,
      currency: 'INR',
      receipt: 'order_rcptid_11'
    })

    # Save the payment details to the database
    payment = Payment.new(
      order_id: order.id,
      amount: payment_amount,
      currency: 'INR',
      payment_status: 'created' # Initial status as 'created'
    )

    if payment.save
      render json: { order_id: order.id, amount: payment_amount, currency: 'INR', key: ENV['RAZORPAY_KEY_ID'] }
    else
      render json: { error: 'Unable to create payment' }, status: :unprocessable_entity
    end
  end

  # Optional: Define a webhook to update payment status upon payment completion
  def update_payment_status
    payment = Payment.find_by(order_id: params[:order_id])
    if payment && params[:razorpay_payment_id].present?
      payment.update(payment_status: 'paid', razorpay_payment_id: params[:razorpay_payment_id])
      render json: { message: 'Payment status updated successfully' }
    else
      render json: { error: 'Payment not found or invalid parameters' }, status: :not_found
    end
  end
end

end
