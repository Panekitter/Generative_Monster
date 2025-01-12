class CreateCharacterService
  require 'openai'
  require 'open-uri'

  def initialize
    @openai = OpenAI::Client.new(access_token: ENV['OPENAI_ACCESS_TOKEN'], log_errrors: true)
  end

  def generate_character(description, type)
    prompt = <<~PROMPT
      「#{description}」 
      上記のdescription_from_userに基づいて「#{type}」を考案し、name_of_character, description_of_character, appearance_of_character, HP, agility, strength, intelligence, name_of_skill_A, description_of_skill_A, name_of_skill_B, description_of_skill_B, name_of_skill_C, description_of_skill_CをJSON形式のみで返してください。 
      - これらはすべて必須項目です。
      - name_of_characterは、可能な限りひねった名前を考えてください。
      - description_of_characterは100~200文字、appearance_of_characterは50~120文字、description_of_skillは10~50文字で書いてください。 
      - description_of_characterは、description_from_userから判断して、弱そうなキャラクターの場合は弱そうな説明にし、強そうなキャラクターの場合は強そうな説明にしてください。
      - HP、agility、strength、intelligenceの合計値の最大値は600です。判断基準は、弱いキャラクターは合計値が300未満、強いキャラクターは合計値が301以上です。
      - description_of_characterに性別に関する記述が含まれている場合、appearance_of_characterでも性別がわかるようにしてください。
      - HP、agility、strength、intelligenceはすべて数字、それ以外はすべて日本語の文章で書いてください。 
    PROMPT

    begin
      response = @openai.chat(
        parameters: {
          model: "gpt-4o-mini",
          messages: [
            { role: "system", content: "あなたはプロのキャラクターデザイナーです。" },
            { role: "user", content: prompt }
          ],
          response_format: { "type": "json_object" },
          temperature: 0.7,
          max_tokens: 1500
        }
      )

      # レスポンス内容を取得
      raw_content = response.dig("choices", 0, "message", "content")
      character_data = JSON.parse(raw_content)

      image_url = DalleService.generate_image(character_data["appearance_of_character"])

      puts "Generated Image URL: #{image_url}" # デバッグ出力

      character_data["image_url"] = upload_to_s3(image_url)

      character_data
    rescue JSON::ParserError => e
      Rails.logger.error("JSON Parse Error: #{e.message}")
      Rails.logger.error("Raw Content: #{raw_content}")
      raise "リクエストを正常に処理できませんでした"
    end
  end

  private

  def upload_to_s3(image_url)
    uploader = CharacterImageUploader.new
    file = URI.open(image_url)
  
    # MiniMagick を使用して JPG に変換
    begin
      processed_image = MiniMagick::Image.read(file)
      processed_image.format("jpg")
  
      temp_file = Tempfile.new(["image", ".jpg"])
      temp_file.binmode
      temp_file.write(processed_image.to_blob)
      temp_file.rewind
  
      uploader.store!(temp_file) # CarrierWaveでアップロード
      temp_file.close
      temp_file.unlink
  
      Rails.logger.info("Uploaded Image URL: #{uploader.url}") # デバッグ出力
  
      if Rails.env.production?
        uploader.url # S3の場合は公開URLを返す
      else
        "/uploads/characters/#{uploader.filename}" # ローカル環境の場合は相対パスを返す
      end
    rescue => e
      Rails.logger.error("Image processing or upload failed: #{e.message}")
      nil # アップロード失敗時はnilを返す
    end
  end  
end
