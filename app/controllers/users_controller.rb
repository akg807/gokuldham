class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token

  def signup
    @user = User.new(user_params)
    @user.r_rfid = SecureRandom.uuid
    if @user.save
      render json: { message: 'User created successfully', user: @user }, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update_role
    Rails.logger.info "inside update_role #{params[:user]}"
    @user = User.find_by(email: params[:user][:email])

    if @user.nil?
      render json: { errors: ['User not found'] }, status: :not_found
    elsif @user.update(role: params[:user][:role])
      render json: { message: "User role updated successfully", user: @user }, status: :ok
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :role, :apartment_id)
  end
end