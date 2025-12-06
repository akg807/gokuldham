class AmenitiesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]
  def create
    @amenity = Amenity.new(amenity_params)
    if @amenity.save
      render json: { message: 'Amenity created successfully', amenity: @amenity }, status: :created
    else
      render json: { errors: @amenity.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def amenity_params
    params.require(:amenity).permit(:name)
  end
end
