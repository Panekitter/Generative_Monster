class TopsController < ApplicationController
  skip_before_action :logged_in?, only: [:home, :terms_of_service, :privacy_policy]

  def home
    if current_user
      redirect_to dashboard_path and return
    end
    
    @characters = fetch_recent_characters
    
    render :index
  end

  def dashboard
    @characters = fetch_recent_characters
  
    # 生成したキャラクターの数
    @character_count = current_user.characters.count

    @win_rate = current_user.battle_count.positive? ? ((current_user.win_count.to_f / current_user.battle_count) * 100).round : 0
  end

  def terms_of_service
    render layout: false
  end

  def privacy_policy
    render layout: false
  end

  private

  def fetch_recent_characters
    Character.order(created_at: :desc).limit(12)
  end
end
