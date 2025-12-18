class RequestsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    ActiveRecord::Base.transaction do
      Rails.logger.info "inside new request #{params[:request]}"
      @request = Request.new(request_params)
      @request.reference_number = rand(100_000_000..999_999_999).to_s
      @request.status = "NOT_STARTED"
      array = [ @request ]

      case @request.request_type
      when "apartment"
        @apartment = Apartment.new(apartment_params)
        @apartment.save
        @request.instance_id = @apartment.id
        @request.eta = 3.months.from_now
        array << @apartment
      when "user"
        @request.eta = 1.month.from_now
      when "amenities"
        @request.eta = 7.days.from_now
      when "other"
        @request.eta = 15.days.from_now
      end


      if @request.save
        render json: { message: "#{@request.request_type} Request submitted", request_details: array }, status: :created
      else
        render json: { errors: @request.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end

  def view
    @user = User.find_by(email: user_params[:email])
    # params[:request_type] = 2
    if @user.role == "Admin"
      @requests = Request.where(status: "NOT_STARTED", request_type: params[:request_type])
      case @requests.request_type
      when "apartment"
        @apartments = Apartment.where(id: @requests.instance_id)
      when "user"
        @persons = User.where(id: @requests.instance_id)
      end

      render json: {message: "Pending requests for #{@requests.request_type}", }
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
end
