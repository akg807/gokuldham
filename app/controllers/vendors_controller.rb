class VendorsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]
  
  def create
    @vendor = Vendor.new(vendor_params)
    rfid =  SecureRandom.uuid
    @vendor.v_rfid = rfid
    if @vendor.save
      render json: { message: 'Vendor created successfully', vendor: @vendor }, status: :created
    else
      render json: { errors: @vendor.errors.full_messages }, status: :unprocessable_entity
    end

  rescue StandardError => e
    Rails.logger.error "Unexpected error in VendorsController#create: #{e.message}"
    render json: { errors: ['Something went wrong, please try again later'] }, status: :internal_server_error
  end



  private

  def vendor_params
    params.require(:vendor).permit(:name, :phone_number, :amenity_id)
  end
end
