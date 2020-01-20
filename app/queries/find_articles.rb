# Service class which implement QueryObject pattern which simplify complicated logic
# related to fetching Articles from DB
class FindArticles < Service::Base
  subject :scope
  param :search, default: nil
  param :order, default: nil
  param :grouped_by, default: nil

  private

  def _call
    apply_includes
    search_filter
    apply_order
    apply_grouped_by
  end

  def validate!
    validate_order!
    validate_grouped_by!
  end

  def validate_order!
    return if order.blank?

    unless order[:field].in?(%w[story_name type name created_at updated_at])
      invalid('Wrong value for order[:field] parameter, should be one of story_name, type, name, created_at, updated_at.')
    end

    unless order[:direction].in?([nil, 'asc', 'desc'])
      invalid('Wrong value for order[:direction] parameter, should be one of asc, desc.')
    end
  end

  def validate_grouped_by!
    return if grouped_by.blank?

    invalid(
      'Wrong grouped_by parameter, should be one of type, name, created_at, updated_at, story'
    ) unless grouped_by.in?(%w[type name created_at updated_at story])
  end

  def apply_includes
    @scope = @scope.includes(:story)
  end

  def search_filter
    return if @search.blank?

    @scope = @scope.where(
      "to_tsvector('english', name || ' ' || text) @@ to_tsquery(?)",
      @search.gsub(' ', ' & ')
    )
  end

  def apply_order
    @scope = if order.blank?
      @scope.order(:id)
    elsif order[:field] == 'story_name'
      @scope.order("stories.name #{order[:direction] || 'ASC'}")
    else
      @scope.order(order[:field] => (order[:direction] || 'ASC'))
    end
  end

  def apply_grouped_by
    return @scope.to_a if grouped_by.blank?

    if grouped_by.in?(%w[created_at updated_at])
      group_by_date_field.to_h do |group_field:, article_ids:|
        [group_field.strftime('%F'), @scope.where(id: article_ids)]
      end
    elsif grouped_by.in?(%w[type name])
      group_by_string_field.to_h do |group_field:, article_ids:|
        [group_field, @scope.where(id: article_ids)]
      end
    elsif grouped_by == 'story'
      group_by_story.to_h do |group_field:, article_count:, article_type_count:, article_id:|
        [group_field, {
          article_count: article_count,
          article_type_count: article_type_count,
          article: Article.find(article_id)
        }]
      end
    else
      raise NotImplementedError
    end
  end

  def group_by_date_field
    get_raw_sql(
      @scope.select("date_trunc('day', articles.#{grouped_by}) AS group_field")
            .select('ARRAY_AGG(articles.id) AS article_ids')
            .group('group_field')
            .reorder('group_field desc')
    )
  end

  def group_by_string_field
    get_raw_sql(
      @scope.select("articles.#{grouped_by} AS group_field")
            .select('ARRAY_AGG(articles.id) AS article_ids')
            .group('group_field')
            .reorder('group_field')
    )
  end

  def group_by_story
    get_raw_sql(
      @scope.select('stories.name AS group_field')
            .select('COUNT(articles.id) AS article_count')
            .select('COUNT(DISTINCT articles.type) AS article_type_count')
            .select('MAX(articles.id) AS article_id')
            .group('group_field')
            .reorder('group_field')
    )
  end

  def get_raw_sql(scope)
    ApplicationRecord.connection.execute(scope.to_sql).map(&:symbolize_keys).tap do |h|
      h[:article_ids] = h[:article_ids][1..-2].split(',')
    end
  end
end
