# Responsible for websocket communication with Stories page
class StoriesChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'stories'
  end
end
