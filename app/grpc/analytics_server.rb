require Rails.root.join("lib/analytics_pb")
require Rails.root.join("lib/analytics_services_pb")

class AnalyticsGrpcServer < AnalyticsService::Service

  def prime_suspects(request, _call)
    result = PrimeSuspectsService.new(
      apartment_id: request.apartment_id,
      crime_from: Time.zone.parse(request.crime_from),
      crime_to: Time.zone.parse(request.crime_to)
    ).call

    suspects = result.map do |s|
      Suspect.new(
        rfid: s[:rfid],
        person_type: s[:person_type],
        name: s[:name],
        entered_at: s[:entered_at].to_s,
        exited_at: s[:exited_at]&.to_s || "",
        duration_inside_minutes: s[:duration_inside_minutes]
      )
    end

    PrimeSuspectsResponse.new(
      apartment_id: request.apartment_id,
      suspect_count: suspects.size,
      prime_suspects: suspects
    )
  end

  def most_active_person(_request, _call)
    result = MostActivePersonService.new.call

    MostActivePersonResponse.new(
      rfid: result[:rfid],
      person_type: result[:person_type],
      name: result[:name],
      total_entries: result[:total_entries]
    )
  end

  def top_defaulter(_request, _call)
    result = TopDefaulterService.new.call

    TopDefaulterResponse.new(
      apartment_id: result[:apartment_id],
      residents: result[:residents],
      total_defaults: result[:total_defaults]
    )
  end

end
