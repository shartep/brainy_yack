module API
  module V1
    # Controller for actions related to Story model
    class StoriesController < ApplicationController
      # before_action :set_story, only: %i[update destroy]

      # GET /stories
      def index
        response = Rails.cache.fetch('stories') do
          @stories = Story.all
          @stories.as_json(only: %i[id name])
        end
        render json: response, status: :ok
      end

      # currently not used, can be used in future for React frontend
      #
      # # POST /stories
      # def create
      #   @story = Story.new(story_params)
      #
      #   if @story.save
      #     render json: {story: @story, notice: 'Story was successfully created.'}, status: :ok
      #     clear_cache
      #     notify_active_user
      #   else
      #     render json: {errors: @story.errors.full_messages}, status: :unprocessable_entity
      #   end
      # end
      #
      # # PATCH/PUT /stories/1
      # def update
      #   if @story.update(story_params)
      #     render json: {story: @story, notice: 'Story was successfully updated.'}, status: :ok
      #     clear_cache
      #     notify_active_user
      #   else
      #     render json: {errors: @story.errors.full_messages}, status: :unprocessable_entity
      #   end
      # end
      #
      # # DELETE /stories/1
      # def destroy
      #   @story.destroy
      #   render json: {notice: 'Story was successfully destroyed.'}, status: :ok
      #   clear_cache
      #   notify_active_users
      # end
      #
      # private
      #
      # # Use callbacks to share common setup or constraints between actions.
      # def set_story
      #   @story = Story.find(params[:id])
      # end
      #
      # # Only allow a trusted parameter "white list" through.
      # def story_params
      #   params.require(:story).permit(:name)
      # end
    end
  end
end
