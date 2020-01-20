# Controller for actions related to Article model
class ArticlesController < ApplicationController
  # TODO: it make sense to think about caching this action in future
  def index
    # articles = FindArticles.new(Article.all, **param_hash).call

    articles = Article.includes(:story)
    if params[:search].present?
      articles = articles.where(
        "to_tsvector('english', name || ' ' || text) @@ to_tsquery(?)",
        params[:search].gsub(' ', ' & ')
      )
    end

    if params[:order].present?
      unless params[:order][:field].in?(%w[story_name type name created_at updated_at]) || params[:order][:direction].in?([nil, 'asc', 'desc'])
        render json: {
          status: :error,
          message: 'Wrong field for order parameter, should be one of story_name, type, name, created_at, updated_at. Or direction parameter, should be one of asc, desc.'
        }, status: :bad_request
        return
      end

      if params[:order][:field] == 'story_name'
        articles = articles.order("stories.name #{params[:order][:direction] || 'ASC'}")
      else
        articles = articles.order(params[:order][:field].to_sym => (params[:order][:direction] || :asc))
      end
    end
    articles = articles.order(:id)

    if params[:grouped_by].present?
      unless params[:grouped_by].in?(%w[type name created_at updated_at story])
        render json: {
          status: :error,
          message: 'Wrong grouped_by parameter, should be one of type, name, created_at, updated_at, story'
        }, status: :bad_request
        return
      end

      if params[:grouped_by].in?(%w[created_at updated_at])
        groups = articles.select("date_trunc('day', articles.#{params[:grouped_by]}) AS group_field")
                         .select("ARRAY_AGG(articles.id) AS ids")
                         .group('group_field')
                         .reorder('group_field desc')

        ah = ApplicationRecord.connection.execute(groups.to_sql).map(&:symbolize_keys)
        hash = {
          params[:grouped_by] => ah.to_h do |group_field:, ids:|
            [
              group_field.strftime('%F'),
              articles.where(id: ids[1..-2].split(',')).map(&method(:article_serializer))
            ]
          end
        }
      elsif params[:grouped_by].in?(%w[type name])
        groups = articles.select("articles.#{params[:grouped_by]} AS group_field")
                         .select("ARRAY_AGG(articles.id) AS ids")
                         .group('group_field')
                         .reorder('group_field')

        ah = ApplicationRecord.connection.execute(groups.to_sql).map(&:symbolize_keys)
        hash = {
          params[:grouped_by] => ah.to_h do |group_field:, ids:|
            [
              group_field,
              articles.where(id: ids[1..-2].split(',')).map(&method(:article_serializer))
            ]
          end
        }
      elsif params[:grouped_by] == 'story'
        groups = articles.select("articles.story_id AS group_field")
                         .select("ARRAY_AGG(articles.id) AS ids")
                         .group('group_field')
                         .reorder('group_field')

        ah = ApplicationRecord.connection.execute(groups.to_sql).map(&:symbolize_keys)

        hash = {
          params[:grouped_by] => ah.to_h do |group_field:, ids:|
            ids = ids[1..-2].split(',')
            la = Article.where(id: ids)
            [
              Story.find(group_field).name,
              {
                article_count: ids.count,
                article_type_count: la.distinct.count(:type),
                article: article_serializer(la.order(created_at: :desc).first)
              }
            ]
          end
        }
      end
    else
      articles = articles.to_a

      hash = { articles: articles.map(&method(:article_serializer)) }
    end

    render json: hash, status: :ok
  end

  private

  def article_serializer(article)
    {
      id: article.id,
      story_name: article.story.name,
      type: article.type,
      name: article.name,
      text: article.text,
      created_at: article.created_at.strftime('%F'),
      updated_at: article.updated_at.strftime('%F')
    }
  end
end
