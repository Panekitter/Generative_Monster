class BattlesController < ApplicationController
  skip_before_action :logged_in?, only: [:show, :og_image_page, :og_image]
  before_action :check_daily_limit, only: [:new, :create]

  def new
    @user_character = current_user.characters.find(params[:user_character_id])
    other_users_characters = Character.where.not(user_id: current_user.id)
    @opponent_character = other_users_characters.sample
    @opponent_skill = @opponent_character.skills.sample

    current_user.increment!(:battle_count)
  end

  def create
    user_character = current_user.characters.find(params[:user_character_id])
    opponent_character = Character.find(params[:opponent_character_id])
    
    selected_user_skill = user_character.skills.find_by(id: params[:user_skill_id])
    selected_opponent_skill = opponent_character.skills.find_by(id: params[:opponent_skill_id])

    # キャラAとキャラBをプロンプト用にフォーマット
    character_a = user_character.attributes.merge(
      skill: {
        name: selected_user_skill.name,
        description: selected_user_skill.description
      }
    )
    character_b = opponent_character.attributes.merge(
      skill: {
        name: selected_opponent_skill.name,
        description: selected_opponent_skill.description
      }
    )

    # 戦闘結果生成
    battle_service = CreateBattleService.new
    battle_result = battle_service.generate_battle_result(character_a, character_b)

    # 勝者を決定
    if battle_result["result"] == "A"
      winner_character = user_character
      winner_user_id = current_user.id
      current_user.increment!(:win_count)
    elsif battle_result["result"] == "B"
      winner_character = opponent_character
      winner_user_id = opponent_character.user_id
    else
      winner_character = nil
      winner_user_id = nil
    end

    # 戦闘結果を保存
    @battle = current_user.battles.create!(
      character_1_id: user_character.id,
      character_2_id: opponent_character.id,
      character_1_name: user_character.name,
      character_2_name: opponent_character.name,
      winner_name: winner_character.name,
      event: battle_result["event"],
      winner_user_id: winner_user_id,
      user_skill_name: selected_user_skill.name,
      opponent_skill_name: selected_opponent_skill.name,
      user_skill_description: selected_user_skill.description,
      opponent_skill_description: selected_opponent_skill.description
    )
    puts @battle
    
    # 戦闘結果ページを表示
    flash[:_just_created] = true
    redirect_to battle_path(@battle)

  rescue => e
    # 戦闘結果の処理でエラーが起きた場合、戦闘回数を -1 に戻す
    current_user.decrement!(:battle_count)
    flash[:alert] = "戦闘処理中にエラーが発生しました。戦闘は無効扱いとなります"
    redirect_to root_path
  end

  def show
    @battle = Battle.find(params[:id])
    @winner_character = if @battle.character_1.present? && @battle.character_1.name == @battle.winner_name
      @battle.character_1
    elsif @battle.character_2.present? && @battle.character_2.name == @battle.winner_name
      @battle.character_2
    else
      nil
    end

    # OGP用のメタタグ設定
    set_meta_tags(
      title: "戦闘結果 - #{@battle.character_1_name} vs #{@battle.character_2_name}",
      description: "戦闘結果: #{@battle.event}",
      og: {
        title: "戦闘結果 - #{@battle.character_1_name} vs #{@battle.character_2_name}",
        description: "戦闘結果: #{@battle.event}",
        type: 'website',
        image: og_image_battle_url(@battle)  # 戦闘結果のOGP画像のURL
      }
    )
  end

  def index
    @user = User.find(params[:user_id])
    @battles = @user.battles.order(created_at: :desc).page(params[:page]).per(10)
  end

  def og_image
    @battle = Battle.find(params[:id])

    og_page_url = og_image_page_battle_url(@battle)

    image_data = `node #{Rails.root.join('public', 'scripts', 'battle_og_image_generator.js')} #{og_page_url}`
    
    send_data image_data, type: 'image/png', disposition: 'inline'
  end

  def og_image_page
    @battle = Battle.find(params[:id])
    render layout: 'og_layout'
  end

  private

  def check_daily_limit
    return if current_user.no_limit?

    if current_user.daily_battle_count >= Battle::DAILY_BATTLE_LIMIT
      redirect_to root_path, alert: "本日の戦闘回数上限に達しています。"
    end
  end

  def battle_params
    params.require(:battle).permit(:character_1_id, :character_2_id, :character_1_name, :character_2_name,:winner_name, :event, :winner_user_id)
  end
end
