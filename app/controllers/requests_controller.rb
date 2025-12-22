class RequestsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    ActiveRecord::Base.transaction do
      Rails.logger.info "inside new request #{params[:request]}"
      @request = Request.new(request_params)
      @request.reference_number = rand(100_000_000..999_999_999).to_s
      @request.status = "NOT_APPROVED"
      array_of_new_request = [ @request ]

      case @request.request_type
      when "apartment"
        @apartment = Apartment.new(apartment_params)
        @apartment.save
        @request.instance_id = @apartment.id
        @request.eta = 3.months.from_nowbr
        array_of_new_request << @apartment
      when "user"
        @request.eta = 1.month.from_now
      when "amenities"
        @request.eta = 7.days.from_now
      when "other"
        @request.eta = 15.days.from_now
      when "vendor"
        @vendor = Vendor.new(vendor_params)
        rfid =  SecureRandom.uuid
        @vendor.v_rfid = rfid
        @vendor.save
        @request.instance_id = @vendor.id
        @request.eta = 15.days.from_now
        array_of_new_request << @vendor
      end


      if @request.save
        render json: { message: "#{@request.request_type} Request submitted", new_request_details: array_of_new_request }, status: :created
      else
        render json: { errors: @request.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end

  def view_requests
    @user = User.find_by(email: params[:email])
    @request_type = params[:request_type]

    case @request_type
    when "apartment"
      @apartment = Apartment.find_by(id: @user.apartment_id)
      @request = Request.where(instance_id: @apartment.id, request_type: 2)
      render json: { message: "All Apartment Requests:", apartment_requests: @request }, status: :ok

    when "user"
      @request = Request.where(instance_id: @user.id, request_type: 1)
      render json: { message: "All User Requests:", user_requests: @request }, status: :ok

    when "amenities"
      @apartment = Apartment.find_by(id: @user.apartment_id)
      @request = Request.where(instance_id: @apartment.id, request_type: 3)
      render json: { message: "All Amenities Requests:", amenities_requests: @request }, status: :ok

    when "other"
      @request = Request.where(instance_id: @user.id, request_type: 0)
      render json: { message: "All other requests:", other_requests: @request }, status: :ok

    end
  end

  def request_approval
    @admin = User.find_by(email: params[:email])
    @reference_number = params[:reference_number]
    @is_approved = params[:is_approved]

    return render json: { message: "Invalid Email" } if @admin.nil?

    return render json: { message: "Access Denied" } if @admin.role != "Admin"

    @request = Request.find_by(reference_number: @reference_number)
    return render json: { message: "Invalid reference number" } if @request.nil?

    if @is_approved == false
      @request.update(status: "DECLINED")
      render json: { message: "Request DECLINED" }

    elsif @is_approved == true
      @request.update(status: "APPROVED")
      if @request.request_type == "apartment"
        @apartment = Apartment.find_by(id: @request.instance_id)
        @apartment.update(approved: true)
        @user = User.find_by(apartment_id: @apartment.id, role: "Owner")
        return render json: { message: "Request APPROVED", user_email_sent: "#{@user.email}" }

      elsif @request.request_type == "vendor"
        @vendor = Vendor.find_by(id: @request.instance_id)
        @vendor.update(approved: true)
        return render json: { message: "Vendor Request approved" }
      end
      render json: { message: "Request APPROVED" }

    else render json: { message: "Invalid parameters" }
    end
  end

  private

  def request_params
    params.require(:request).permit(:description, :request_type)
  end

  def apartment_params
    params.require(:apartment).permit(:number, :floor, :block, amenities_flag: [])
  end

  def user_params
    params.require(:users).permit(:email)
  end

  def vendor_params
    params.require(:vendor).permit(:name, :phone_number, :amenity_id)
  end
end
