class SessionsController < ApplicationController
  skip_before_action :logged_in?, only: :create

  def create
    if (user, is_new_user = User.find_or_create_from_auth_hash(auth_hash)) && user.persisted?
      log_in user
      if is_new_user
        redirect_to root_path, notice: 'アカウントを作成しました'
      else
        redirect_to root_path, notice: 'ログインしました'
      end
    else
      redirect_to root_path, alert: 'ログインに失敗しました'
    end
  end

  def destroy
    log_out
    redirect_to root_path
  end

  private
  
  def auth_hash
    request.env['omniauth.auth']
  end
end
