# frozen_string_literal: true

require "jwt"
module JsonWebToken
  extend ActiveSupport::Concern
  SECRET_KEY = Rails.application.secrets.secret_key_base.to_s

  def jwt_encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  def jwt_decode(token)
    body = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new body
    # rescue
    # nil
  end
end
