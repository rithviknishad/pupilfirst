module Founders
  class PostPaymentService
    def initialize(payment)
      @payment = payment
    end

    def execute
      raise 'PostPaymentService was called for an unpaid payment!' unless @payment.paid?

      # If payment was made within the active billing period, there is nothing to be done.
      return if @payment.billing_start_at.future?

      # Otherwise, the billing period will have to be updated.
      payment_duration = @payment.billing_end_at - @payment.billing_start_at
      @payment.update!(billing_start_at: Time.zone.now, billing_end_at: Time.zone.now + payment_duration)
    end
  end
end
