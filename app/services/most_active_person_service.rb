class MostActivePersonService
  def call
    top = EntryLog
            .select("rfid, COUNT(*) AS entries_count")
            .group(:rfid)
            .order(Arel.sql("entries_count DESC"))
            .limit(1)
            .first

    return nil unless top

    user   = User.find_by(r_rfid: top.rfid)
    vendor = Vendor.find_by(v_rfid: top.rfid)

    person =
      if vendor
        { type: "Vendor", name: vendor.name }
      elsif user
        { type: user.role || "Resident", name: user.name }
      else
        { type: "Unknown", name: "Unidentified" }
      end

    {
      rfid: top.rfid,
      person_type: person[:type],
      name: person[:name],
      total_entries: top.entries_count.to_i
    }
  end
end
