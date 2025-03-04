class TopsController < ApplicationController
  skip_before_action :logged_in?, only: [:home, :index]

  def home
    if current_user
      redirect_to dashboard_path and return
    end
    
    @characters = fetch_recent_characters
    
    render :index
  end

  def index
    @characters = fetch_recent_characters
  end

  def dashboard
    @characters = fetch_recent_characters
  
    # 生成したキャラクターの数
    @character_count = current_user.characters.count
  
    # 行った戦闘回数
    @battles_count = Battle.where(character_1: current_user.characters).count
  
    # 勝利した戦闘の数 (character_1が自分のキャラの場合のみ計算)
    @wins_count = Battle.where(character_1: current_user.characters, winner_user_id: current_user.id).count
  
    # 勝率計算 (戦闘回数が0の場合は0%)
    @win_rate = @battles_count.positive? ? ((@wins_count.to_f / @battles_count) * 100).round(2) : 0
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
