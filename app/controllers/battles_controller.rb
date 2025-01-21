class BattlesController < ApplicationController
  def new
    @user_character = current_user.characters.find(params[:user_character_id])
    other_users_characters = Character.where.not(user_id: current_user.id)
    @opponent_character = other_users_characters.sample
    @opponent_skill = @opponent_character.skills.sample
  end

  def create
    user_character = current_user.characters.find(params[:user_character_id])
    opponent_character = Character.find(params[:opponent_character_id])
    selected_user_skill = params[:user_skill]
    selected_opponent_skill = params[:opponent_skill]

    # キャラAとキャラBをプロンプト用にフォーマット
    character_a = user_character.attributes.merge(skill: selected_user_skill)
    character_b = opponent_character.attributes.merge(skill: selected_opponent_skill)

    # 戦闘結果生成
    battle_service = CreateBattleService.new
    battle_result = battle_service.generate_battle_result(character_a, character_b)

    # 戦闘結果を保存
    @battle = Battle.create!(
      character_1_id: user_character.id,
      character_2_id: opponent_character.id,
      winner_name: battle_result["result"],
      event: battle_result["event"]
    )

    # 戦闘結果ページを表示
    redirect_to battle_path(@battle)
  end

  def show
    @battle = Battle.find(params[:id])
  end

  def index
    user = User.find(session[:user_id])
    @battles = Battle.where(character_1: user.characters).includes(:character_1, :character_2).order(created_at: :desc).page(params[:page]).per(10)
  end
end
