class Api::V1::ForumThreadsController < ApplicationController
  before_action :set_forum_thread, only: %i[ show update destroy ]

  # GET /forum_threads
  def index
    @forum_threads = ForumThread.all

    render json: ForumThreadSerializer.new(@forum_threads, options).serialized_json
  end

  # GET /forum_threads/1
  def show
    render json: ForumThreadSerializer.new(@forum_thread, options).serialized_json
  end

  # POST /forum_threads
  def create
    @forum_thread = ForumThread.new(forum_thread_params)

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
    @forum_thread.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_forum_thread
      @forum_thread = ForumThread.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def forum_thread_params
      params.require(:forum_thread).permit(:title, :description)
    end

    def options
      @options ||= { include: %i[comments]}
    end
end
