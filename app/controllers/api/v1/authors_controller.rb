class Api::V1::AuthorsController < ApplicationController
  before_action :set_author, only: %i[ show update destroy ]
  before_action :authorized, only: %i[comments forum_threads]

  # GET /authors
  def index
    @authors = Author.all

    render json: AuthorSerializer.new(@authors, options).serialized_json
  end

  def forum_threads
    @author = Author.find(@author_id)
    @forum_threads = @author.forum_threads.order("#{params[:sort_by]}": :desc)
    render json: ForumThreadSerializer.new(@forum_threads, options).serialized_json
  end

  def comments
    @author = Author.find(@author_id)
    @comments = @author.comments.order("#{params[:sort_by]}": :desc)
    render json: CommentSerializer.new(@comments).serialized_json
  end

  # GET /authors/1
  def show
    render json: @author
  end

  # POST /authors
  def create
    Rails.logger.debug params.inspect
    @author = Author.new(name: params[:name], password: params[:password])

    if @author.valid? && @author.save
      payload = {user: @author.id}
      token = JWT.encode(payload, 'okcool', "HS256")
      render json: {token: token}, status: :created  
    elsif @author.errors.count == 1 && @author.errors[:name].first == "has already been taken"
      foundAuthor = Author.find_by(name: params[:name])
      if foundAuthor && foundAuthor.authenticate(params[:password])
        payload = {user: foundAuthor.id}
        token = JWT.encode(payload, 'okcool', 'HS256')
        render json: {token: token}
      else
        render json: {error:"Failed, Password Incorrect"}, status: :unauthorized
      end
    else
      render json: @author.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /authors/1
  def update
    if @author.update(author_params)
      render json: @author
    else
      render json: @author.errors, status: :unprocessable_entity
    end
  end

  # DELETE /authors/1
  def destroy
    @author.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_author
      @author = Author.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def author_params
      params.require(:author).permit(:name, :password)
    end

    def options
      @options ||= { include: %i[comments forum_threads]}
    end
end
