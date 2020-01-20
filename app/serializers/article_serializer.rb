# Service class which encapsulate serialization logic for index action
class ArticleSerializer < Service::Base
  subject :collection
  param :grouped_by, default: nil

  private

  def _call
    if grouped_by.blank?
      { articles: collection.map(&method(:record_serializer)) }
    elsif grouped_by == 'story'
      {
        grouped_by => collection.transform_values do |group|
          group[:article] = record_serializer(group[:article])
          group
        end
      }
    else
      {
        grouped_by => collection.transform_values do |scope|
          scope.map(&method(:record_serializer))
        end
      }
    end
  end

  def validate!
    validate_grouped_by!
  end

  def validate_grouped_by!
    return if grouped_by.blank?

    unless grouped_by.in?(%w[type name created_at updated_at story])
      invalid(
        'Wrong grouped_by parameter, should be one of type, name, created_at, updated_at, story'
      )
    end
  end

  def record_serializer(article)
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
