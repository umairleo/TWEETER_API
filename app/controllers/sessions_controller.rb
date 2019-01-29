class SessionsController < ApplicationController
  before_action :authenticate_user, only: [:sign_out]

  def sign_up
    @user = User.new(sign_up_params)
    if @user.save
      success_user_created
    else
      error_user_save
    end
  end

  def sign_in
    @user = User.find_by_email(params[:email])
    if @user.nil?
      error_invalid_credentials
    else
      @user.authenticate(params[:password])
      if @user
        @session = @user.sessions.build
        if @session.save
          success_user_logged_in
        else
          error_user_session
        end
      else
        error_invalid_credentials
      end
    end
  end

  def sign_out
    @token = request.headers['token']
    session = Session.find_by_token(@token)
    session&.expire!
    success_sign_out
  end

  protected

  def success_user_created
    render status: :created, template: 'sessions/show.json.jbuilder'
  end

  def error_user_save
    render status: :unprocessable_entity, json: { errors: @user.errors.full_messages }
  end

  def error_invalid_credentials
    render status: :unprocessable_entity, json: { errors: ['You have provided wrong credentials'] }
  end

  def success_user_logged_in
    render status: :created, template: 'sessions/login.json.jbuilder'
  end

  def error_user_session
    render status: :unprocessable_entity, json: { errors: @session.errors.full_messages }
  end

  def success_sign_out
    render status: :no_content, json: {}
  end

  private

  def sign_up_params
    params.permit(:email, :name, :password, :username, :bio)
  end
end