# Controller for actions related to Article model
class ArticlesController < ApplicationController
  def index
    response = Rails.cache.fetch(cache_key(:search, :order, :grouped_by)) do
      articles = FindArticles.new(scope: Article.all, **param_hash).call

      ArticleSerializer.new(collection: articles, **param_hash).call
    end

    render json: response, status: :ok
  rescue Service::ValidationError => e
    render json: {status: :error, message: e.message}, status: :bad_request
  end

  def new
    @article = Article.new
  end

  def create
    clear_cache
  end

  def update
    clear_cache
  end

  def destroy
    clear_cache
  end

  private

  def clear_cache
    Rails.cache.clear
  end
end
