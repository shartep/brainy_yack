# base class for all controllers, helpful for different helper methods related to params, current_user etc.
class ApplicationController < ActionController::Base
  def clear_cache
    Rails.cache.clear
  end

  def notify_active_users
    # implement notification via ActiveCable here
  end
end
