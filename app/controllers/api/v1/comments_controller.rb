class Api::V1::CommentsController < ApplicationController
  before_action :set_comment, only: %i[ destroy ]

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
    @comment = Comment.new(comment_params)

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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def comment_params
      params.require(:comment).permit(:text, :author, :forum_thread_id)
    end
end
