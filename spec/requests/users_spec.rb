require "rails_helper"

RSpec.describe UsersController, type: :request do
  let(:invalid_attributes) { {blabla: "yoo"} }
  let(:user) { create(:user) }
  let(:headers) {
    {
      "Accept" => "application/json",
      "Content-Type" => "application/json"
    }
  }
  let(:auth_headers) { JWTHelpers.auth_headers(headers, user) }

  describe "GET /geomap" do
    it "returns a success response" do
      get geomap_user_url(user), headers: headers
      expect(response).to be_successful
    end
  end

  describe "GET /me" do
    context "logged in" do
      it "renders a JSON response with the user" do
        get me_users_url, headers: auth_headers, as: :json
        expect(response).to be_successful
      end
    end

    context "logged out" do
      it "returns unauthenticated" do
        get me_users_url, headers: headers, as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET /profile' do
    it "renders a JSON response with the user" do
      get profile_user_url(user), headers: headers, as: :json
      expect(response).to be_successful
    end
  end

  describe "GET /index" do
    it "renders a successful response" do
      create(:user)
      get users_url, as: :json
      expect(response).to be_successful
    end

    it "paginates users" do
      25.times { create(:user) }
      get users_url({page: 2}), as: :json
      expect(JSON.parse(response.body)["users"].size).to eq(1)
    end
  end

  describe "GET /show" do
    context "query by id" do
      it "renders a successful response" do
        get user_url(user.id), as: :json
        expect(response).to be_successful
      end
    end
    context "query by username" do
      it "renders a successful response" do
        get user_url(user.username), as: :json
        user_url(user.username, {username: true})
        expect(response).to be_successful
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        {username: "new_username", about_you: "new_about_you"}
      }

      it "updates the requested user" do
        user
        patch "/users/#{user.username}",
          params: {user: new_attributes},
          headers: auth_headers,
          as: :json
        user.reload
        expect(user.username).to eq("new_username")
        expect(user.about_you).to eq("new_about_you")
      end

      it "renders a JSON response with the user" do
        patch user_url(user),
          params: {user: new_attributes}, headers: auth_headers, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested user" do
      user
      expect {
        delete user_url(user), headers: auth_headers, as: :json
      }.to change(User, :count).by(-1)
    end
  end
end
