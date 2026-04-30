class ApplicationController < ActionController::Base

  # Отключение проверки CSRF-токена.
  # Терубется только если у приложения в дальнейшем будет frontend,
  # иначе: ActionController::Base -> ActionController::API
  protect_from_forgery with: :null_session

  before_action :authenticate_user!

  private

  def authenticate_user!
    @current_user = find_user_by_jwt || find_user_by_api_key
    render_json("Not  authorized", :unauthorized) unless @current_user
  end

  def find_user_by_jwt
    header = request.headers['Authorization']
    # Начало с "Bearer " - стандарт JWT-токена
    return nil unless header&.start_with?('Bearer ')

    token = header.split(' ').last
    decoded_user_data = JsonWebToken.decode(token)
    User.find_by(id: decoded_user_data[:user_id]) if decoded_user_data
  end

  def find_user_by_api_key
    api_key = request.headers['X-API-Key'] || params[:api_key]
    user = User.find_by(api_key: api_key) if api_key
    user if user&.api_key_valid?
  end

  def render_json(data, status = :ok)
    if data.is_a?(String)
      render json: { message: data }, status: status
    elsif data.respond_to?(:errors) && data.errors.any?
      render json: { errors: data.errors.full_messages }, status: :unprocessable_entity
    else
      render json: data, status: status
    end
  end
end
