module API
  module V1
    # Controller for API actions related to Article model
    class ArticlesController < ApplicationController
      before_action :set_article, only: %i[update destroy]

      def index
        response = Rails.cache.fetch(cache_key(:search, :order, :grouped_by)) do
          articles = FindArticles.new(scope: Article.all, **param_hash).call

          ArticleSerializer.new(collection: articles, **param_hash).call
        end

        render json: response, status: :ok
      rescue Service::ValidationError => e
        render json: {errors: e.errors}, status: :unprocessable_entity
      end

      # POST /stories
      def create
        @article = Article.new(article_params)

        if @article.save
          render json: {article: @article, notice: 'Article was successfully created.'}, status: :ok
          clear_cache
          notify_active_users
        else
          render json: {errors: @article.errors.map(&:message)}, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /stories/1
      def update
        if @article.update(article_params)
          render json: {article: @article, notice: 'Article was successfully updated.'}, status: :ok
          clear_cache
          notify_active_users
        else
          render json: {errors: @article.errors.map(&:message)}, status: :unprocessable_entity
        end
      end

      # DELETE /stories/1
      def destroy
        @article.destroy
        render json: {notice: 'Article was successfully destroyed.'}, status: :ok
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
        Rails.cache.clear
      end

      def notify_active_users
        # implement notification via ActiveCable here
      end
    end
  end
end
