# base class for all controllers, helpful for different helper methods related to params, current_user etc.
class ApplicationController < ActionController::Base
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
