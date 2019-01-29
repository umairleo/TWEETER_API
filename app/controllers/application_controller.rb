class ApplicationController < ActionController::API
  attr_reader :current_user

  def authenticate_user
    token = request.headers['token']
    if token
      session = Session.get_session(token)
      if session
        @current_user = session.user
      else
        error_unauthorized
      end
    else
      error_unauthorized
    end
  end

  protected

  def error_unauthorized
    render status: :unauthorized, json: { errors: ['You are not logged in to perform this action'] }
  end
end