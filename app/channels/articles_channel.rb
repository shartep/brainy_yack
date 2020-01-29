# Responsible for websocket communication with Articles page
class ArticlesChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'articles'
  end
end
