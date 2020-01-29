# Service class which implement QueryObject pattern which simplify complicated logic
# related to fetching Articles from DB
class FindArticles < Service::Base
  subject :scope
  param :search, default: nil, &:strip
  param :order_field, default: nil
  param :order_direction, default: nil
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
    return if order_field.blank?

    unless order_field.in?(%w[story_name type name text created_at updated_at])
      invalid(
        order_field:
          'Wrong value for order[:field] parameter, should be one of story_name, type, name, text, '\
          'created_at, updated_at.'
      )
    end

    return if order_direction.in?([nil, 'asc', 'desc'])

    invalid(order_deirection: 'Wrong value for order[:direction] parameter, should be one of asc, desc.')
  end

  def validate_grouped_by!
    return if grouped_by.blank? || grouped_by.in?(%w[type name created_at updated_at story])

    invalid(
      grouped_by: 'Wrong grouped_by parameter, should be one of type, name, created_at, updated_at, story'
    )
  end

  def apply_includes
    @scope = @scope.includes(:story) if grouped_by.blank?
  end

  def search_filter
    return if search.blank?

    # Postgres full text search solution
    @scope = @scope.where(
      "to_tsvector('english', articles.name || ' ' || articles.text) @@ to_tsquery(?)",
      search.gsub(' ', ' & ')
    )
  end

  def apply_order
    @scope =
      if order_field.blank?
        @scope
      elsif order_field == 'story_name'
        @scope.order("stories.name #{order_direction || 'ASC'}")
      else
        @scope.order(order_field => (order_direction || 'ASC'))
      end.order(id: :desc)
  end

  def apply_grouped_by
    return @scope.to_a if grouped_by.blank?

    if grouped_by.in?(%w[created_at updated_at])
      group_by_date_field
    elsif grouped_by.in?(%w[type name])
      group_by_string_field
    elsif grouped_by == 'story'
      group_by_story
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
    ).to_h do |group_field:, article_ids:|
      [group_field.strftime('%F'), @scope.includes(:story).where(id: article_ids)]
    end
  end

  def group_by_string_field
    get_raw_sql(
      @scope.select("articles.#{grouped_by} AS group_field")
            .select('ARRAY_AGG(articles.id) AS article_ids')
            .group('group_field')
            .reorder('group_field')
    ).to_h do |group_field:, article_ids:|
      [group_field, @scope.includes(:story).where(id: article_ids)]
    end
  end

  def group_by_story
    get_raw_sql(
      @scope.select('stories.name AS group_field')
            .select('COUNT(articles.id) AS article_count')
            .select('COUNT(DISTINCT articles.type) AS article_type_count')
            .select('MAX(articles.id) AS article_id')
            .joins('JOIN stories ON stories.id = articles.story_id')
            .group('group_field')
            .reorder('group_field')
    ).to_h do |group_field:, article_count:, article_type_count:, article_id:|
      [group_field, {
        article_count: article_count,
        article_type_count: article_type_count,
        article: Article.includes(:story).find(article_id)
      }]
    end
  end

  def get_raw_sql(scope)
    ApplicationRecord.connection.execute(scope.to_sql).map do |row|
      row.symbolize_keys!.tap(&method(:array_arg_convertor!))
    end
  end

  # ARRAY_AGG aggregation function returns string like `{234,675,8554}`, we convert it in regular Array here
  def array_arg_convertor!(hash)
    hash[:article_ids] = hash[:article_ids][1..-2].split(',') if hash[:article_ids].present?
  end
end
