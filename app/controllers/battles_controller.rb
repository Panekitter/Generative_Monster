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
    
    selected_user_skill = user_character.skills.find_by(id: params[:user_skill_id])
    selected_opponent_skill = opponent_character.skills.find_by(id: params[:opponent_skill_id])

    # キャラAとキャラBをプロンプト用にフォーマット
    character_a = user_character.attributes.merge(
      skill: {
        name: selected_user_skill&.name,
        description: selected_user_skill&.description
      }
    )
    character_b = opponent_character.attributes.merge(
      skill: {
        name: selected_opponent_skill&.name,
        description: selected_opponent_skill&.description
      }
    )

    # 戦闘結果生成
    battle_service = CreateBattleService.new
    battle_result = battle_service.generate_battle_result(character_a, character_b)

    # 勝者を決定
    if battle_result["result"] == "A"
      winner_character = user_character
      winner_user_id = current_user.id
    elsif battle_result["result"] == "B"
      winner_character = opponent_character
      winner_user_id = opponent_character.user_id
    else
      winner_character = nil
      winner_user_id = nil
    end

    # 戦闘結果を保存
    @battle = Battle.create!(
      character_1_id: user_character.id,
      character_2_id: opponent_character.id,
      winner_name: winner_character&.name,
      event: battle_result["event"],
      winner_user_id: winner_user_id
    )
    puts @battle
    
    # 戦闘結果ページを表示
    redirect_to battle_path(@battle)
  end

  def show
    @battle = Battle.find(params[:id])

    # OGP用のメタタグ設定
    set_meta_tags(
      title: "戦闘結果 - #{@battle.character_1.name} vs #{@battle.character_2.name}",
      description: "戦闘結果: #{@battle.event}",
      og: {
        title: "戦闘結果 - #{@battle.character_1.name} vs #{@battle.character_2.name}",
        description: "戦闘結果: #{@battle.event}",
        type: 'website',
        image: og_image_battle_result_url(@battle)  # 戦闘結果のOGP画像のURL
      },
      twitter: {
        card: 'summary_large_image',
        title: "戦闘結果 - #{@battle.character_1.name} vs #{@battle.character_2.name}",
        description: "戦闘結果: #{@battle.event}",
        image: og_image_battle_result_url(@battle)  # Twitterカード用の画像
      }
    )
  end

  def index
    user = User.find(session[:user_id])
    @battles = Battle.where(character_1: user.characters).includes(:character_1, :character_2).order(created_at: :desc).page(params[:page]).per(10)
  end

  def og_image
    battle = Battle.find(params[:id])

    battle_url = battle_url(battle)

    image_data = `node #{Rails.root.join('public', 'scripts', 'battle_og_image_generator.js')} #{battle_url}`

    send_data image_data, type: 'image/png', disposition: 'inline'
  end
end
