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

  def user_pending_payments
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
  invoice = PaymentService.process_payment(params[:id], params[:amount])

  render json: {
    message: "Payment successful",
    invoice: {
      id: invoice.id,
      status: invoice.status,
      paid_amount: invoice.paid_amount,
      total_amount: invoice.total_amount,
      remaining_balance: invoice.total_amount - invoice.paid_amount
    }
  }, status: :ok

  rescue PaymentService::PaymentError => e
  render json: { error: e.message }, status: :unprocessable_entity
  end
end
# for partial payments render necessary fields
# payments records should be stored
# pending payments to be ranamed to userpendingpayments
# apply ka name change to apply penalty
# bulk generation ke time pe paid amount should be defaulted to 0
# ENUMS for Invoice should be capital
# if amount is not number like true .. expection handling
