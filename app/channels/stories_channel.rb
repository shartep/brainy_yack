# Responsible for websocket communication with Stories page
class StoriesChannel < ApplicationCable::Channel
  def subscribed
    stream_for 'stories'
  end

  # currently not used, can be used in future for React frontend
  # def create(data)
  #   story = Story.new(stories_params(data))
  #
  #   return unless story.save
  #
  #   clear_cache
  #   notify_active_users
  # end
  #
  # def update(data)
  #   story = Story.find(data['id'])
  #
  #   return unless story.update(stories_params(data))
  #
  #   clear_cache
  #   notify_active_users
  # end
  #
  # def destroy(data)
  #   Story.find(data['id']).destroy
  #   clear_cache
  #   notify_active_users
  # end
  #
  # private
  #
  # def notify_channel
  #   'stories:stories'
  # end
  #
  # def stories_params(data)
  #   data.symbolize_keys.slice(:name)
  # end
end
