class AnalyticsController < ApplicationController
  def prime_suspects
    result = PrimeSuspectsService.new(
      apartment_id: params[:apartment_id],
      crime_from: Time.zone.parse(params[:crime_from]),
      crime_to: Time.zone.parse(params[:crime_to])
    ).call

    render json: {
      apartment_id: params[:apartment_id],
      suspect_count: result.size,
      prime_suspects: result
    }
  end

  # def most_active_person
  #   result = MostActivePersonService.new.call
  #   return render json: { message: "No entry data found" } unless result

  #   render json: result
  # end

  # def top_defaulter
  #   result = TopDefaulterService.new.call
  #   return render json: { message: "No defaulters found" } unless result

  #   render json: result
  # end
end
