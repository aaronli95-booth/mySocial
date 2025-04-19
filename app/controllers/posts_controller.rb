class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy ]

  # GET /posts or /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1 or /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Current.user.posts.new
  end

  # GET /posts/1/edit
  def edit
    unless @post.user == Current.user
      redirect_to posts_path, alert: "You can only edit your own posts."
    end
  end

  # POST /posts or /posts.json
  def create
    @post = Current.user.posts.new(post_params)

    if @post.save
      # Notify all friends about the new post
      (Current.user.friends + Current.user.inverse_friends).uniq.each do |friend|
        NotificationService.notify(
          recipient: friend,
          actor: Current.user,
          action_type: 'new_post',
          notifiable: @post
        )
      end
      redirect_to profile_path, notice: "Post was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    if @post.user != Current.user
      redirect_to posts_path, alert: "You can only edit your own posts."
      return
    end

    if @post.update(post_params)
      redirect_to profile_path, notice: "Post was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    if @post.user != Current.user
      redirect_to posts_path, alert: "You can only delete your own posts."
      return
    end

    @post.destroy
    redirect_to profile_path, notice: "Post was successfully deleted."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:caption, :body, images: [])
    end
end
