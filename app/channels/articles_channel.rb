# Responsible for websocket communication with Articles page
class ArticlesChannel < ApplicationCable::Channel
  def subscribed
    stream_for 'articles'
  end

  def create(data)
    article = Article.new(article_params(data))

    return unless article.save

    clear_cache
    notify_active_users
  end

  def update(data)
    article = Article.find(data['id'])

    return unless article.update(article_params(data))

    clear_cache
    notify_active_users
  end

  def destroy(data)
    Article.find(data['id']).destroy
    clear_cache
    notify_active_users
  end

  private

  def notify_channel
    'articles:articles'
  end

  def article_params(data)
    data.symbolize_keys.slice(:type, :name, :text, :story_id)
  end
end
