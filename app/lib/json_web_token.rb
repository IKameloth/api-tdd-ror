class JsonWebToken
  # secret to encode and decode token
  HMAC_SECRET = Rails.application.credentials.secret_key_base

  def self.encode(payload, exp = 24.hours.from_now)
    # set expiry to 24 hours
    payload[:exp] = exp.to_i

    # sign token with app secret
    JWT.encode(payload, HMAC_SECRET)
  end

  def self.decode(token)
    # get payload, first index in decode arr
    body = JWT.decode(token, HMAC_SECRET)[0]
    HashWithIndifferentAccess.new body

    # rescue from all decode errors
  rescue JWT::DecodeError => exception
    raise ExceptionHandler::InvalidToken, exception.message
  end
end
