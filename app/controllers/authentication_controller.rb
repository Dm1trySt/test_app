class AuthenticationController < ApplicationController

  skip_before_action :authenticate_user!, raise: false

  def login
    user = User.find_by(email: params[:email])

    # authenticate - метод has_secure_password (сверяет пароль с хешем)
    if user&.authenticate(params[:password])

      token = JsonWebToken.encode(user_id: user.id)

      render_json( {
        token: token,
        email: user.email,
        message: "Login successful"
      }, :ok)
    else
      render_json({ error: 'Invalid email or password' }, :unauthorized)
    end
  end
end
