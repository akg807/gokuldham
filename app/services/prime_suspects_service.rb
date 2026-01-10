class PrimeSuspectsService
  def initialize(apartment_id:, crime_from:, crime_to:)
    @apartment_id = apartment_id
    @crime_from = crime_from
    @crime_to = crime_to
    normalize_time_window
  end

  def call
    suspects = EntryLog
                 .where(apartment_id: @apartment_id)
                 .where("in_time <= ?", @crime_to)
                 .where("out_time IS NULL OR out_time >= ?", @crime_from)
                 .order(:in_time)

    rfids = suspects.map(&:rfid)

    users   = User.where(r_rfid: rfids).index_by(&:r_rfid)
    vendors = Vendor.where(v_rfid: rfids).index_by(&:v_rfid)

    suspects.map do |log|
      user   = users[log.rfid]
      vendor = vendors[log.rfid]

      person =
        if vendor
          { type: "Vendor", name: vendor.name }
        elsif user
          { type: user.role || "Resident", name: user.name }
        else
          { type: "Unknown", name: "Unidentified" }
        end

      {
        rfid: log.rfid,
        person_type: person[:type],
        name: person[:name],
        entered_at: log.in_time,
        exited_at: log.out_time,
        duration_inside_minutes: ((log.out_time || Time.current) - log.in_time).to_i / 60
      }
    end
  end

  private

  def normalize_time_window
    @crime_from, @crime_to = @crime_to, @crime_from if @crime_from > @crime_to
  end
end
