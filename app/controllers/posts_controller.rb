class PostsController < ApplicationController
  before_action :set_post, only: %i[show update destroy create_comment]
  before_action :authenticate_user!, only: %i[create update destroy create_comment]

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)
    @post.user = current_user

    if @post.save
      render :show, status: :created, location: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    if @post.update(post_params)
      render :show, status: :ok, location: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
  end

  def create_comment
    @comment = PostComment.new(
      body: params[:comment][:body],
      user: current_user,
      post: @post
    )
    if @comment.save
      render :show, status: :created, location: @post
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  private

  def set_post
    @post = Post.find(params[:id].split('-').last)
  end

  def post_comment_params
    params.require(:post_comment).permit(:body, :post_id)
  end

  def post_params
    params.require(:post).permit(:title, :body)
  end
end
