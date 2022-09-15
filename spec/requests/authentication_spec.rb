require "rails_helper"

RSpec.describe "Authentications", type: :request do
  describe "POST /login" do
    context "when the request is valid" do
      it "returns a token" do
        user = User.create(email: "flo@flo.flo", username: "flov", password: "password")
        post "/auth/login", params: {email: user.email, password: user.password}
        expect(response).to have_http_status(200)
        expect(response.body).to include("token")
        expect(response.headers).to include("Set-Cookie")
      end
    end

    context "when the request is invalid" do
      it "returns an error message" do
        post "/auth/login", params: {email: "xyz@s.de", password: "xxx"}
        expect(response).to have_http_status(401)
        expect(response.body).to include("Invalid email or password")
      end
    end
  end
end
