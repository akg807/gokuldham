class EntryLogsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def logs
    resident = User.find_by(r_rfid: params[:rfid])
    vendor   = Vendor.find_by(v_rfid: params[:rfid])

    entry_details = EntryLogsService
                      .new
                      .entry_log_generate(vendor, resident, params[:rfid], user_params)

    render json: { message: "record created/updated", value: entry_details }, status: :ok
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.record.errors.full_messages }, status: :unprocessable_entity
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private

  def user_params
    params.fetch(:users, {}).permit(:email, :name, :apartment_id)
  end
end
