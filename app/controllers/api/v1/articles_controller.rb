module API
  module V1
    # Controller for API actions related to Article model
    class ArticlesController < ApplicationController
      def index
        response = Rails.cache.fetch(cache_key(:search, :order_field, :order_direction, :grouped_by)) do
          articles = FindArticles.new(scope: Article.all, **param_hash).call

          ArticleSerializer.new(collection: articles, **param_hash).call
        end

        render json: response, status: :ok
      rescue Service::ValidationError => e
        render json: {errors: e.errors}, status: :unprocessable_entity
      end
    end
  end
end
