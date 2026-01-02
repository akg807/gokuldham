class InvoicesController < ApplicationController
  skip_before_action :verify_authenticity_token
  # include MaintanenceService
  def generate_maintenance
    admin = User.find_by(email: params[:email])

    return render json: { message: "Invalid Email" } if admin.nil?
    return render json: { message: "Access Denied" } if admin.role != "Admin"

    created_count = MaintanenceService.new.bulk_generate

    render json: { message: "Maintenance invoices generated successfully", invoices_created: created_count }, status: :ok
  end

  def pending_payments
  user = User.where.not(role: "Guest")
             .find_by(email: params[:email])

  unless user
    return render json: { error: "User not found" }, status: :not_found
  end

  pending_invoices = Invoice.where(apartment_id: user.apartment_id, status: "pending")

  render json: {
    message: "All pending payments",
    invoices: pending_invoices
  }, status: :ok
  end

  def pay_maintenance
  invoice = Invoice.find_by(id: params[:id])
  return render json: { error: "Invoice not found" }, status: :not_found unless invoice

  PenaltyService.apply(invoice)

  amount = params[:amount].to_f
  return render json: { error: "Invalid payment amount" }, status: :unprocessable_entity if amount <= 0

  invoice.paid_amount ||= 0
  remaining = invoice.total_amount - invoice.paid_amount

  if amount > remaining
    return render json: {
      error: "Payment exceeds remaining balance",
      remaining_balance: remaining
    }, status: :unprocessable_entity
  end

  invoice.paid_amount += amount

  if invoice.paid_amount >= invoice.total_amount
    invoice.status = "paid"
  else
    invoice.status = "partially_paid"
  end

  invoice.transaction_id = SecureRandom.uuid
  invoice.save!

  render json: {
    message: "Payment successful",
    invoice: invoice
  }, status: :ok
  end

end
