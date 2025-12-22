class EntryLogsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def logs
    @user_log = EntryLog.find_by(rfid: params[:rfid])
    @resident = User.find_by(r_rfid: params[:rfid])
    @vendor = Vendor.find_by(v_rfid: params[:rfid])

    if @vendor.nil? && @resident.present?
      logs = @resident.entry_logs
      entry_details = create_entry_log(@resident.r_rfid, logs)

    elsif @vendor.present? && @resident.nil?
      logs = @vendor.entry_logs
      entry_details = create_entry_log(@vendor.v_rfid, logs)

    elsif @vendor.nil? && @resident.nil?
      @guest = User.new(user_params)
      @guest.r_rfid = params[:rfid]
      @guest.role = "Guest"
      @guest.save
      # @guest = User.create(name: params[:name], email: params[:email], role: "Guest", r_rfid: params[:rfid], apartment_id: params[:apt_id])
      logs = @guest.entry_logs
      entry_details = create_entry_log(@guest.r_rfid, logs)
    end
    render json: { message: "record created/updated", value: entry_details }
  end

  private

  def create_entry_log(rfid, logs)
    if logs.exists?
      if logs.last.out_time.nil?
        logs.last.update(out_time: Time.now)
      else
        EntryLog.create(rfid: rfid, in_time: Time.now, out_time: nil)
      end
    else
      EntryLog.create(rfid: rfid, in_time: Time.now, out_time: nil)
    end
  end

  def user_params
    params.require(:users).permit(:email, :name, :apartment_id)
  end
end
