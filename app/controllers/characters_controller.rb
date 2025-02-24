class CharactersController < ApplicationController
  skip_before_action :logged_in?, only: [:index, :show, :og_image_page, :og_image]

  def index
    @user = User.find(params[:user_id])
    @characters = @user.characters.includes(:skills).order(created_at: :desc)
  end

  def new
    @character = Character.new
  end
  
  def create
    user = User.find(session[:user_id])
    service = CreateCharacterService.new
    character_data = service.generate_character(params[:description_from_user], params[:type])
  
    # キャラクターを作成
    @character = user.characters.new(
      name: character_data["name_of_character"],
      description: character_data["description_of_character"],
      hp: character_data["HP"],
      agility: character_data["agility"],
      strength: character_data["strength"],
      intelligence: character_data["intelligence"],
      appearance: character_data["appearance_of_character"]
    )
  
    # 画像を設定
    if Rails.env.production?
      # S3のURLを使用
      @character.image = URI.open(character_data["image_url"])
    else
      # ローカルファイルパスを使用
      image_path = Rails.root.join("public", character_data["image_url"].sub(/^\/uploads\//, "uploads/"))
      if File.exist?(image_path)
        @character.image = File.open(image_path)
      else
        Rails.logger.error("Image file not found: #{image_path}")
      end
    end
  
    # 保存処理
    if @character.save
      Rails.logger.info("Character saved successfully with image: #{@character.image.url}")
      # スキルを保存
      @character.skills.create!(name: character_data["name_of_skill_A"], description: character_data["description_of_skill_A"])
      @character.skills.create!(name: character_data["name_of_skill_B"], description: character_data["description_of_skill_B"])
      @character.skills.create!(name: character_data["name_of_skill_C"], description: character_data["description_of_skill_C"])
  
      redirect_to character_path(@character), notice: "キャラクターが生成されました"
    else
      Rails.logger.error("Failed to save character: #{@character.errors.full_messages.join(', ')}")
      flash[:alert] = "キャラクターの生成に失敗しました: #{@character.errors.full_messages.join(', ')}"
      render :new
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
    @character.destroy!
    redirect_to user_characters_path(current_user), notice: "キャラクターを削除しました。"
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
