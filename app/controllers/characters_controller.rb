class CharactersController < ApplicationController
  skip_before_action :logged_in?, only: [:show, :og_image_page, :og_image]

  def index
    @user = User.find(params[:user_id])
    @characters = @user.characters.includes(:skills).order(created_at: :desc)
  end

  def new
    @character = Character.new
  end
  
  def create
    user = current_user
    description = params[:description_from_user]
    type = params[:type]

    service = CreateCharacterService.new

    begin
      # サービス呼び出し
      character_data = service.generate_character(description, type)
    rescue => e
      # ログに詳細情報を出力
      Rails.logger.error("Error in character creation: #{e.class} - #{e.message}")
      Rails.logger.error(e.backtrace.join("\n"))

      # ユーザーには一般的なメッセージのみ表示
      flash[:alert] = "キャラクター生成中にエラーが発生しました。再度お試しください。"
      redirect_to root_path
      return
    end

    # キャラクター生成に成功した場合の処理
    character = user.characters.new(
      name: character_data["name_of_character"],
      description: character_data["description_of_character"],
      description_from_user: description,
      hp: character_data["HP"],
      agility: character_data["agility"],
      strength: character_data["strength"],
      intelligence: character_data["intelligence"],
      appearance: character_data["appearance_of_character"]
    )

    # ダウンロードした画像をCarrierWaveのimageに割り当て
    Rails.logger.info "DEBUG: character_data = #{character_data.inspect}"
    Rails.logger.info "DEBUG: image_url = #{character_data['image_url'].inspect if character_data}"
    character.image = URI.open(character_data["image_url"])

    if character.save
      character.skills.create!(name: character_data["name_of_skill_A"], description: character_data["description_of_skill_A"])
      character.skills.create!(name: character_data["name_of_skill_B"], description: character_data["description_of_skill_B"])
      character.skills.create!(name: character_data["name_of_skill_C"], description: character_data["description_of_skill_C"])

      redirect_to character_path(character), notice: "キャラクター生成完了！"
    else
      flash[:alert] = "キャラクター生成に失敗しました。"
      redirect_to new_character_path
    end
  end

  def show
    @character = Character.find(params[:id])
    @skills = @character.skills

    set_meta_tags(
      title: @character.name,
      description: @character.description,
      og: {
        title: @character.name,
        description: @character.description,
        type: 'website',
        image: og_image_page_character_url(@character)
      }
    )
  end

  def destroy
    @character = current_user.characters.find_by(id: params[:id])
    @character_id = @character.id  # IDを保存しておく
    @character.destroy!
    
    respond_to do |format|
      format.html { redirect_to user_characters_path(current_user), notice: "キャラクターを削除しました。" }
      format.turbo_stream { 
        render turbo_stream: turbo_stream.remove("character-#{@character_id}")
      }
    end
  end

  def og_image
    @character = Character.find(params[:id])

    og_page_url = og_image_page_character_url(@character)

    image_data = `node #{Rails.root.join('public', 'scripts', 'character_og_image_generator.js')} #{og_page_url}`

    send_data image_data, type: 'image/png', disposition: 'inline'
  end

  def og_image_page
    @character = Character.find(params[:id])
    render layout: 'og_layout'
  end
end
