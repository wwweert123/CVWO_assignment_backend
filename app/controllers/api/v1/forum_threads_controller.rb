class Api::V1::ForumThreadsController < ApplicationController
  before_action :set_forum_thread, only: %i[ show update destroy like likestatus]
  before_action :authorized, only: %i[create like likestatus destroy]

  # GET /forum_threads
  def index
    if params[:tag_topic]
      @forum_threads = ForumThread.tagged_with(params[:tag_topic]).order("#{params[:sort_by]}": :desc)
    else
      @forum_threads = ForumThread.all.order("#{params[:sort_by]}": :desc)
    end
    render json: ForumThreadSerializer.new(@forum_threads, options).serialized_json
  end

  # GET /forum_threads/1
  def show
    render json: ForumThreadSerializer.new(@forum_thread, options).serialized_json
  end

  # POST /forum_threads
  def create
    @forum_thread = ForumThread.new(title: params[:title], description: params[:description], author_id: @author_id)
    if params[:tag].present?
      @forum_thread.tag_list.add(params[:tag_list], parse: true)
    end

    if @forum_thread.save
      render json: ForumThreadSerializer.new(@forum_thread).serialized_json, status: :created
    else
      render json: @forum_thread.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /forum_threads/1
  def update
    if @forum_thread.update(forum_thread_params)
      render json: ForumThreadSerializer.new(@forum_thread, options).serialized_json
    else
      render json: @forum_thread.errors, status: :unprocessable_entity
    end
  end

  # DELETE /forum_threads/1
  def destroy
    if @forum_thread.author_id == @author_id
      @forum_thread.destroy!
    else
      render json: {error: "not allowed"}, status: :unauthorized
    end
  end

  def likestatus
    data = {}
    begin
      user = Author.find(@author_id)
    rescue
      data["liked"] = false;
      data["disliked"] = false;
    else
      data["liked"] = user.voted_up_on? @forum_thread
      data["disliked"] = user.voted_down_on? @forum_thread
    ensure
      data["tally"] = @forum_thread.cached_weighted_score
    end
    render json: data, status: :accepted
  end

  def like
    data = {}
    begin
      user = Author.find(@author_id)
    rescue
      data["error"] = "Can't find user" 
      data["liked"] = false;
      data["disliked"] = false;
    else
      if params[:user_action] == 'like'
        @forum_thread.liked_by user
        # render json: @forum_thread, status: :accepted
      elsif params[:user_action] == 'dislike'
        @forum_thread.disliked_by user
        # render json: @forum_thread, status: :accepted
      elsif params[:user_action] == 'unlike'
        @forum_thread.unliked_by user
        # render json: @forum_thread, status: :accepted
      elsif params[:user_action] == 'undislike'
        @forum_thread.undisliked_by user
        # render json: @forum_thread, status: :accepted
      end
      data["liked"] = user.voted_up_on? @forum_thread
      data["disliked"] = user.voted_down_on? @forum_thread
    ensure
      data["tally"] = @forum_thread.cached_weighted_score
    end
    render json: data, status: :accepted
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_forum_thread
      @forum_thread = ForumThread.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def forum_thread_params
      params.require(:forum_thread).permit(:title, :description, :tag_list)
    end

    def options
      @options ||= { include: %i[comments authors]}
    end
end
