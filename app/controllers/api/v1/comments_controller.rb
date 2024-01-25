class Api::V1::CommentsController < ApplicationController
  before_action :set_comment, only: %i[ destroy like likestatus]
  before_action :authorized, only: %i[create like likestatus]

  # # GET /comments
  # def index
  #   @comments = Comment.all

  #   render json: @comments
  # end

  # # GET /comments/1
  # def show
  #   render json: @comment
  # end

  # POST /comments
  def create
    @comment = Comment.new(text: params[:text], forum_thread_id: params[:forum_thread_id], author_id: @author_id)

    if @comment.save
      render json: CommentSerializer.new(@comment).serialized_json, status: :created
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  # # PATCH/PUT /comments/1
  # def update
  #   if @comment.update(comment_params)
  #     render json: @comment
  #   else
  #     render json: @comment.errors, status: :unprocessable_entity
  #   end
  # end

  # DELETE /comments/1
  def destroy
    @comment.destroy!
  end

  def likestatus
    data = {}
    begin
      user = Author.find(@author_id)
    rescue
      data["liked"] = false;
      data["disliked"] = false;
    else
      data["liked"] = user.voted_up_on? @comment
      data["disliked"] = user.voted_down_on? @comment
    ensure
      data["tally"] = @comment.cached_weighted_score
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
        @comment.liked_by user
        # render json: @forum_thread, status: :accepted
      elsif params[:user_action] == 'dislike'
        @comment.disliked_by user
        # render json: @forum_thread, status: :accepted
      elsif params[:user_action] == 'unlike'
        @comment.unliked_by user
        # render json: @forum_thread, status: :accepted
      elsif params[:user_action] == 'undislike'
        @comment.undisliked_by user
        # render json: @forum_thread, status: :accepted
      end
      data["liked"] = user.voted_up_on? @comment
      data["disliked"] = user.voted_down_on? @comment
    ensure
      data["tally"] = @comment.cached_weighted_score
    end
    render json: data, status: :accepted
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def comment_params
      params.require(:comment).permit(:text, :forum_thread_id)
    end
end
