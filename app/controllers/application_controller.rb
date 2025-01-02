class ApplicationController < ActionController::Base
  include SessionsHelper
  before_action :logged_in?

  def logged_in?
    unless current_user
      redirect_to root_path, alert: "ログインが必要です。" and return
    end
  end
end