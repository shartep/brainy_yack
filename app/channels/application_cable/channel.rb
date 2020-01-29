module ApplicationCable
  # base class for all channels
  class Channel < ActionCable::Channel::Base
    private

    def clear_cache
      Rails.cache.clear
    end

    def notify_active_users
      ActionCable.server.broadcast(notify_channel, {})
    end

    def notify_channel
      raise NotImplementedError
    end
  end
end
