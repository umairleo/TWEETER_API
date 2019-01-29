class TweetsController < ApplicationController
  before_action :authenticate_user, only: %i[create update destroy]
  before_action :set_tweet, only: %i[show update destroy]
  before_action :authorize_user, only: %i[update destroy]

  # GET /tweets
  # GET /tweets.json
  def index
    @tweets = Tweet.all
    success_tweet_index
  end

  # GET /tweets/1
  # GET /tweets/1.json
  def show
    success_tweet_show
  end

  # POST /tweets
  # POST /tweets.json
  def create
    @tweet = Tweet.new(tweet_params)
    @tweet.user = current_user

    if @tweet.save
      success_tweet_create
    else
      error_tweet_save
    end
  end

  # PATCH/PUT /tweets/1
  # PATCH/PUT /tweets/1.json
  def update
    if @tweet.update(tweet_params)
      success_tweet_show
    else
      error_tweet_save
    end
  end

  # DELETE /tweets/1
  # DELETE /tweets/1.json
  def destroy
    @tweet.destroy
    success_tweet_destroy
  end

  protected

  def error_forbidden
    render status: :forbidden, json: { errors: ['You are not authorized to perform this action'] }
  end

  def success_tweet_index
    render status: :ok, template: 'tweets/index.json.jbuilder'
  end

  def success_tweet_show
    render status: :ok, template: 'tweets/show.json.jbuilder'
  end

  def success_tweet_create
    render status: :created, template: 'tweets/show.json.jbuilder'
  end

  def error_tweet_save
    render status: :unprocessable_entity, json: { errors: @tweet.errors.full_messages }
  end

  def success_tweet_destroy
    render status: :no_content, json: {}
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_tweet
    @tweet = Tweet.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def tweet_params
    params.permit(:body)
  end

  def authorize_user
    error_forbidden if @tweet.user != current_user
  end
end