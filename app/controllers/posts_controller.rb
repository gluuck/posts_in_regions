class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: %i[show edit update destroy attach_files attach_images change_state]

  # GET /posts or /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1 or /posts/1.json
  def show
    set_region
  end

  # GET /posts/new
  def new
    @post = Post.new
    set_region
  end

  # GET /posts/1/edit
  def edit
    authorize @post, policy_class: PostPolicy
    set_region
  end

  # POST /posts or /posts.json
  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    @post.region = set_region
    files = params[:post][:files]
    images = params[:post][:images]
    authorize @post
    respond_to do |format|
      if @post.save
        attach_files(@post, files) if files.present?
        attach_images(@post, images) if images.present?
        AdminPostApproveJob.perform_later(@post) if current_user.admin?
        format.html { redirect_to set_region, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to set_region, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy

    respond_to do |format|
      format.html { redirect_to region_posts_path, status: :see_other, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def change_state
    state = params[:post][:aasm_state] + '!'
    PostChangeStateJob.perform_later(@post, state)
    redirect_to region_path(params[:region_id])
  end

  def attach_files(post, files)
    files.each do |file|
      tempfile = Tempfile.new('files', Rails.root.join('tmp'))
      tempfile.binmode
      tempfile.rewind
      post.files.attach(io: File.open(tempfile.path), filename: file)
    end
  rescue ActiveSupport::MessageVerifier::InvalidSignature => e
    logger.error "File attachment failed: #{e.message}"
  end

  def attach_images(post, images)
    images.each do |image|
      tempfile = Tempfile.new('images', Rails.root.join('tmp'))
      tempfile.binmode
      tempfile.rewind
      post.images.attach(io: File.open(tempfile.path), filename: image)
    end
  rescue ActiveSupport::MessageVerifier::InvalidSignature => e
    logger.error "Image attachment failed: #{e.message}"
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params[:id])
  end

  def set_region
    @region = Region.find(params[:region_id])
  end

  # Only allow a list of trusted parameters through.
  def post_params
    params.require(:post).permit(:title, :body, :region_id, :user_id, :aasm_state, files: [], images: [])
  end
end
