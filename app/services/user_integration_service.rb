require 'rest-client'

class UserIntegrationService

  API_URL = Rails.application.credentials.dig(:users_api, :url)
  API_KEY = Rails.application.credentials.dig(:users_api, :api_key)

  LOGGER = ActiveSupport::TaggedLogging.new(Rails.logger)


  def self.notify_user_created(user)
    data = {
      user_id: user.id,
      email: user.email,
      created_at: user.created_at
    }.to_json

    begin
      RestClient::Request.execute(
        method: :post,
        url: API_URL,
        payload: data,
        headers: { content_type: :json, 'X-API-KEY' => API_KEY },
        timeout: 5,
        open_timeout: 2
      )

      LOGGER.tagged("USER_INTEGRATION", "UserID: #{user.id}") do
        begin
          LOGGER.info({ event: "request_started", url: API_URL }.to_json)

          response = RestClient::Request.execute(
            method: :post,
            url: API_URL,
            payload: data,
            headers: { content_type: :json, 'X-API-KEY' => API_KEY },
            timeout: 5,
            open_timeout: 2
          )

          LOGGER.info({ event: "success", code: response.code }.to_json)
          return true

        rescue RestClient::ExceptionWithResponse => e
          LOGGER.error({
                         event: "api_error",
                         code: e.response&.code,
                         body: e.response&.body
                       }.to_json)
        rescue StandardError => e
          LOGGER.error({ event: "error", message: e.message }.to_json)
        end

        false
      end
    end
  end
end
