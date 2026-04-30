class User < ApplicationRecord

  has_secure_password

  normalizes :email, with: ->(email) { email.strip.downcase }

  before_validation :generate_api_key, on: :create

  validates :email,
            presence: true,
            uniqueness: true,
            format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :password,
            presence: true,
            length: { minimum: 10 },
            allow_nil: true

  def api_key_valid?
    api_key_expires_at.present? && api_key_expires_at > Time.current
  end

  def update_key!
    update!(
      api_key: SecureRandom.hex(24),
      api_key_expires_at: 30.days.from_now
    )
  end

  private

  def generate_api_key
    # Генерация 48-ми символьной случайной строки (hex от 24 байт)
    self.api_key ||= SecureRandom.hex(24)
    self.api_key_expires_at ||= 30.days.from_now
  end
end
