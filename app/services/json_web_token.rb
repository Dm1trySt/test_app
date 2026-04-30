# Сервис для работы с JSON Web Tokens (gem JWT).
#
# Для чего он нужен:
# Централизованное получение SECRET_KEY в едином месте;
# Исключение error 500, которую отдаст JWT decode, если передать не валидные данные.

class JsonWebToken

  SECRET_KEY = Rails.application.secret_key_base

  def self.encode(user_data, live_time = Time.current.end_of_day)
    user_data[:exp] = live_time.to_i
    JWT.encode(user_data, SECRET_KEY)
  end

  # return { "user_id" => 1, "exp" => 1 }
  # с возможность обращаться как :key, так и "key"
  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new(decoded)
  rescue JWT::DecodeError
    nil
  end
end