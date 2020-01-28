module API
  module V1
    # base class for all controllers, helpful for different helper methods related to params, current_user etc.
    class ApplicationController < ActionController::API
      private

      # As I delegate a lot of validation and param conversion to services, I don't need most
      # of strong params functionality. So, this method just produces the regular Ruby Hash with
      # Symbol keys, listed as arguments -- ready to passed as keyword args.
      def param_hash(*keys)
        params.to_unsafe_h
              .deep_symbolize_keys
              .then { |hash| keys.empty? ? hash : hash.slice(*keys) }
              .compact
      end

      def cache_key(*keys)
        param_hash(*keys).then do |params|
          keys.map { |k| "#{k}--#{params[k]}" }.join('/')
        end
      end

      def clear_cache
        Rails.cache.clear
      end

      def notify_active_users
        # implement notification via ActiveCable here
      end
    end
  end
end
