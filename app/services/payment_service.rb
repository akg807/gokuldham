class PaymentService
  class PaymentError < StandardError; end

  def self.process_payment(invoice_id, raw_amount)
    invoice = Invoice.find_by(id: invoice_id)
    raise PaymentError, "Invoice not found" unless invoice

    PenaltyService.apply_penalty(invoice)

    unless raw_amount.is_a?(Numeric) || raw_amount.to_s.match?(/\A\d+(\.\d{1,2})?\z/)
      raise PaymentError, "Invalid payment amount format"
    end

    amount = raw_amount.to_f
    raise PaymentError, "Payment amount must be greater than zero" if amount <= 0

    ActiveRecord::Base.transaction do
      invoice.lock!

      invoice.paid_amount ||= 0
      remaining = invoice.total_amount - invoice.paid_amount
      raise PaymentError, "Payment exceeds remaining balance" if amount > remaining

      invoice.paid_amount += amount

      invoice.status =
        if invoice.paid_amount >= invoice.total_amount
          "paid"
        else
          "partially_paid"
        end

      txn_id = SecureRandom.uuid
      invoice.transaction_id = txn_id
      invoice.save!

      Payment.create!(
        invoice: invoice,
        amount: amount,
        transaction_id: txn_id,
        status: "success",
        paid_at: Time.current
      )

      invoice
    end
  end
end
