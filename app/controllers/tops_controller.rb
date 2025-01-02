class TopsController < ApplicationController
  skip_before_action :logged_in?, only: [:home, :index]

  def home
    if current_user
      redirect_to dashboard_path and return
    end
    render :index
  end

  def index

  end

  def dashboard

  end
end
