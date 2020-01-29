# Responsible for websocket communication with Articles page
class ArticlesChannel < ApplicationCable::Channel
  def subscribed
    stream_for 'articles'
  end
end
