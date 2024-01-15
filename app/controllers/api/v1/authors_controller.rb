class Api::V1::AuthorsController < ApplicationController
  before_action :set_author, only: %i[ show update destroy ]

  # GET /authors
  def index
    @authors = Author.all

    render json: AuthorSerializer.new(@authors, options).serialized_json
  end

  # GET /authors/1
  def show
    render json: @author
  end

  def forum_threads
    @authors = Author.find(params[:id])
    @forum_threads = @authors.forum_threads.order("#{params[:sort_by]}": :desc)
    render json: ForumThreadSerializer.new(@forum_threads, options).serialized_json
  end

  # POST /authors
  def create
    @author = Author.new(author_params)

    if @author.save
      render json: @author, status: :created, location: @author
    elsif @author.errors.count == 1 && @author.errors[:name].first == "has already been taken"
      foundAuthor = Author.find_by(name: params[:name])
      render json: foundAuthor, status: :accepted
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
      params.require(:author).permit(:name)
    end

    def options
      @options ||= { include: %i[comments forum_threads]}
    end
end
