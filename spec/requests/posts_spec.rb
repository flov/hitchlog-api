require "rails_helper"

RSpec.describe "/posts", type: :request do
  let(:post_entity) { FactoryBot.create(:post) }
  let(:user) { FactoryBot.create(:confirmed_user, id: 1) }
  let(:not_admin) { FactoryBot.create(:confirmed_user, id: 2) }
  let(:valid_attributes) {
    {body: "example body", title: "example title"}
  }
  let(:invalid_attributes) { {body: ""} }
  let(:headers) { {"Accept" => "application/json", "Content-Type" => "application/json"} }
  let(:auth_headers) { JWTHelpers.auth_headers(headers, user) }
  let(:not_admin_headers) { JWTHelpers.auth_headers(headers, not_admin) }

  describe "GET /index" do
    it "renders a successful response" do
      post_entity
      get posts_url, headers: auth_headers, as: :json
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      get post_url(post_entity.to_param), headers: auth_headers, as: :json
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "only logged in user with id = 1 can create" do
      context "with valid parameters" do
        it "renders a JSON response with the new post" do
          expect {
            post posts_url,
              params: {post: {body: "example body", title: "example title"}},
              headers: auth_headers,
              as: :json
          }.to change(Post, :count).by(1)
          expect(response).to have_http_status(:created)
          expect(response.body).to match(/example body/)
          expect(response.content_type).to match(a_string_including("application/json"))
        end
      end
      context "with invalid parameters" do
        it "does not create a new Post" do
          expect {
            post posts_url,
              params: {post: invalid_attributes}, as: :json
          }.to change(Post, :count).by(0)
        end

        it "renders a JSON response with errors for the new post" do
          post posts_url,
            params: {post: invalid_attributes}, headers: auth_headers, as: :json
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to match(a_string_including("application/json"))
        end
      end
    end

    context "user with id != 1" do
      it "renders a JSON response with errors for the new post" do
        post posts_url,
          params: {post: valid_attributes}, headers: not_admin_headers, as: :json
        expect(response).to have_http_status(:unauthorized)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "not logged in user" do
      it "renders a JSON response with errors for the new post" do
        post posts_url, params: {post: valid_attributes}, as: :json
        expect(response).to have_http_status(:unauthorized)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Post" do
        expect {
          post posts_url,
            params: {post: valid_attributes},
            headers: auth_headers,
            as: :json
        }.to change(Post, :count).by(1)
      end

      it "renders a JSON response with the new post" do
        post posts_url,
          params: {post: valid_attributes}, headers: auth_headers, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Post" do
        expect {
          post posts_url,
            params: {post: invalid_attributes}, as: :json
        }.to change(Post, :count).by(0)
      end

      it "renders a JSON response with errors for the new post" do
        post posts_url,
          params: {post: invalid_attributes}, headers: auth_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe "POST /create_comment" do
    describe "logged in" do
      context "with valid parameters" do
        it "creates a new Comment" do
          expect {
            post create_comment_post_url(post_entity.to_param),
              params: {post_comment: {body: "comment body"}},
              headers: auth_headers,
              as: :json
          }.to change(PostComment, :count).by(1)
        end

        it 'renders a JSON response with the new comment' do
          post create_comment_post_url(post_entity.to_param),
            params: {post_comment: {body: "comment body"}},
            headers: auth_headers,
            as: :json
          expect(response).to have_http_status(:created)
          expect(response.content_type).to match(a_string_including("application/json"))
          expect(response.body).to match(/comment body/)
        end
      end

      context "with invalid parameters" do
        it "does not create a new Comment" do
          expect {
            post create_comment_post_url(post_entity.to_param),
              params: {post_comment: {body: ""}},
              headers: auth_headers,
              as: :json
          }.to change(PostComment, :count).by(0)
        end

        it "renders a JSON response with errors for the new comment" do
          post create_comment_post_url(post_entity.to_param),
            params: {post_comment: {body: ""}},
            headers: auth_headers,
            as: :json
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to match(a_string_including("application/json"))
        end
      end
    end

    describe "not logged in" do
      it "renders a 401" do
        post create_comment_post_url(post_entity.to_param),
          params: {post_comment: {body: ""}},
          as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
  
  describe "PATCH /update" do
    context "when user id is not 1" do
      it 'should not be authorized' do
        patch post_url(post_entity.to_param),
          params: {post: valid_attributes},
          headers: not_admin_headers,
          as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
    context "when user id is 1" do
      context "with valid parameters" do
        it 'updates the post and renders a JSON response with the post' do
          patch post_url(post_entity.to_param),
            params: {post: valid_attributes},
            headers: auth_headers,
            as: :json
          expect(response).to have_http_status(:ok)
          expect(response.content_type).to match(a_string_including("application/json"))
        end
      end
      context "with invalid parameters" do
        it "renders a JSON response with errors for the post" do
          patch post_url(post_entity.to_param),
            params: {post: {title: ""}},
            headers: auth_headers,
            as: :json
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to match(a_string_including("application/json"))
        end
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested post" do
      post_entity
      expect {
        delete post_url(post_entity), headers: auth_headers, as: :json
      }.to change(Post, :count).by(-1)
    end
  end
end
