require "rails_helper"

RSpec.describe "/users", type: :request do
  let(:valid_attributes) {}
  let(:invalid_attributes) {}
  let(:valid_headers) { {} }
  let(:user) { create(:user) }
  let(:token) { jwt_encode({user_id: user.id}) }
  let(:logged_in_headers) { {Authorization: token} }

  describe "GET /me" do
    context "logged in" do
      it "renders a JSON response with the user" do
        get me_users_url, headers: logged_in_headers, as: :json
        expect(response).to be_successful
      end
    end
    context "logged out" do
      it "returns unauthenticated" do
        get me_users_url, as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "GET /index" do
    xit "renders a successful response" do
      User.create! valid_attributes
      get users_url, headers: valid_headers, as: :json
      expect(response).to be_successful
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

  describe "POST /create" do
    context "with valid parameters" do
      xit "creates a new User" do
        expect {
          post users_url,
            params: {user: valid_attributes}, headers: valid_headers, as: :json
        }.to change(User, :count).by(1)
      end

      xit "renders a JSON response with the new user" do
        post users_url,
          params: {user: valid_attributes}, headers: valid_headers, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      xit "does not create a new User" do
        expect {
          post users_url,
            params: {user: invalid_attributes}, as: :json
        }.to change(User, :count).by(0)
      end

      xit "renders a JSON response with errors for the new user" do
        post users_url,
          params: {user: invalid_attributes}, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      xit "updates the requested user" do
        user = User.create! valid_attributes
        patch user_url(user),
          params: {user: new_attributes}, headers: valid_headers, as: :json
        user.reload
        skip("Add assertions for updated state")
      end

      xit "renders a JSON response with the user" do
        user = User.create! valid_attributes
        patch user_url(user),
          params: {user: new_attributes}, headers: valid_headers, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      xit "renders a JSON response with errors for the user" do
        user = User.create! valid_attributes
        patch user_url(user),
          params: {user: invalid_attributes}, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe "DELETE /destroy" do
    xit "destroys the requested user" do
      user = User.create! valid_attributes
      expect {
        delete user_url(user), headers: valid_headers, as: :json
      }.to change(User, :count).by(-1)
    end
  end
end
