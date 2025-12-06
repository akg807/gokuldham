class ApartmentsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

  def create
    @apartment = Apartment.new(apartment_params)
    if @apartment.save
      render json: { message: 'Apartment created successfully', apartment: @apartment }, status: :created
    else
      render json: { errors: @apartment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def apartment_params
    params.require(:apartment).permit(:number, :floor, :block, amenities_flag: [])
  end
end
