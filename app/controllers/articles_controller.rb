# Controller for actions related to Article model
class ArticlesController < ApplicationController
  before_action :set_article, only: %i[show edit update destroy]

  def index
    response = Rails.cache.fetch(cache_key(:search, :order, :grouped_by)) do
      articles = FindArticles.new(scope: Article.all, **param_hash).call

      ArticleSerializer.new(collection: articles, **param_hash).call
    end

    render json: response, status: :ok
  rescue Service::ValidationError => e
    render json: {status: :error, message: e.message}, status: :bad_request
  end

  # GET /stories/1
  def show; end

  # GET /stories/new
  def new
    @article = Article.new
  end

  # GET /stories/1/edit
  def edit; end

  # POST /stories
  def create
    @article = Article.new(article_params)

    if @article.save
      redirect_to @article, notice: 'Article was successfully created.'
      clear_cache
      notify_active_users
    else
      render :new
    end
  end

  # PATCH/PUT /stories/1
  def update
    if @article.update(article_params)
      redirect_to @article, notice: 'Article was successfully updated.'
      clear_cache
      notify_active_users
    else
      render :edit
    end
  end

  # DELETE /stories/1
  def destroy
    @article.destroy
    redirect_to articles_url, notice: 'Article was successfully destroyed.'
    clear_cache
    notify_active_users
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_article
    @article = Article.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def article_params
    params.require(:article).permit(:type, :name, :text, :story_id)
  end

  def clear_cache
    # Rails.cache.clear
  end

  def notify_active_users
    # implement notification via ActiveCable here
  end
end
