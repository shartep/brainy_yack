# Controller for actions related to Story model
class StoriesController < ApplicationController
  before_action :set_story, only: %i[show edit update destroy]

  # GET /stories
  def index
    @stories = Story.all
  end

  # GET /stories/1
  def show; end

  # GET /stories/new
  def new
    @story = Story.new
  end

  # GET /stories/1/edit
  def edit; end

  # POST /stories
  def create
    @story = Story.new(story_params)

    if @story.save
      clear_cache
      notify_active_users

      redirect_to @story, notice: 'Story was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /stories/1
  def update
    if @story.update(story_params)
      clear_cache
      notify_active_users

      redirect_to @story, notice: 'Story was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /stories/1
  def destroy
    @story.destroy

    clear_cache
    notify_active_users

    redirect_to stories_url, notice: 'Story was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_story
    @story = Story.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def story_params
    params.require(:story).permit(:name)
  end

  def notify_channel
    'stories'
  end
end
