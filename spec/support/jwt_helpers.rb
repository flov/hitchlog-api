module JWTHelpers
  def self.auth_headers(headers, user, scope: nil, aud: nil)
    scope ||= Devise::Mapping.find_scope!(user)
    aud ||= headers[Warden::JWTAuth.config.aud_header]
    token, payload = Warden::JWTAuth::UserEncoder.new.call(
      user, scope, aud
    )
    user.on_jwt_dispatch(token, payload) if user.respond_to?(:on_jwt_dispatch)
    Warden::JWTAuth::HeaderParser.to_headers(headers, token)
  end
end
