class EntryLogsService
  def entry_log_generate(vendor, resident, rfid, user_params = {})
    user = resolve_user(vendor, resident, rfid, user_params)
    logs = user.entry_logs
    create_entry_log(user_identifier(user), logs)
  end

  private

  def resolve_user(vendor, resident, rfid, user_params)
    return resident if resident.present?
    return vendor   if vendor.present?

    User.create!(
      r_rfid: rfid,
      role: "Guest",
      name:  user_params[:name].presence  || "Guest-#{rfid[0..5]}",
      email: user_params[:email].presence || "guest_#{rfid[0..5]}@ams.local",
      apartment_id: user_params[:apartment_id]
    )
  end

  def user_identifier(user)
    user.is_a?(Vendor) ? user.v_rfid : user.r_rfid
  end

  def create_entry_log(rfid, logs)
    if logs.exists? && logs.last.out_time.nil?
      logs.last.update!(out_time: Time.current)
      logs.last
    else
      EntryLog.create!(rfid: rfid, in_time: Time.current)
    end
  end
end
