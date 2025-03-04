class CreateCharacterService
  require 'openai'
  require 'open-uri'

  def initialize
    @openai = OpenAI::Client.new(access_token: ENV['OPENAI_ACCESS_TOKEN'])
  end

  def generate_character(description, type)
    prompt = <<~PROMPT
      「#{description}」 
      上記のdescription_from_userに基づいて「#{type}」を考案し、name_of_character, description_of_character, appearance_of_character, HP, agility, strength, intelligence, name_of_skill_A, description_of_skill_A, name_of_skill_B, description_of_skill_B, name_of_skill_C, description_of_skill_CをJSON形式のみで返してください。 
      - これらはすべて必須項目です。
      - 必ず、HP、agility、strength、intelligenceは数字、appearance_of_characterは英語、name_of_character、description_of_characterは日本語で書いてください。 
      - name_of_characterは、可能な限りひねった名前を考えてください。
      - スキルはすべて、サポートスキルではなく単独で使用する前提のスキルにしてください。
      - description_of_characterは200~300文字、appearance_of_characterは100~200文字、description_of_skillは10~50文字で書いてください。 
      - description_of_characterは、description_from_userから判断して、弱そうなキャラクターの場合は弱そうな説明にし、強そうなキャラクターの場合は強そうな説明にしてください。
      - HP、agility、strength、intelligenceの合計値の最大値は600です。判断基準は、弱いキャラクターは合計値が300未満、強いキャラクターは合計値が301以上です。
      - description_of_characterに性別に関する記述が含まれている場合、appearance_of_characterでも性別がわかるようにしてください。
    PROMPT

    puts "Create Character Prompt: #{prompt}" # デバッグ出力

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

      image_prompt = generate_image_prompt(character_data["appearance_of_character"], type)
      image_url = NebiusFluxService.generate_image(image_prompt)

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
      
    puts file
        
    begin
        # MiniMagickで処理
      processed_image = MiniMagick::Image.read(file)
      processed_image.format("jpg")
  
      temp_file = Tempfile.new(["image", ".jpg"])
      temp_file.binmode
      temp_file.write(processed_image.to_blob)
      temp_file.rewind
  
      uploader.store!(temp_file)
      temp_file.close
      temp_file.unlink
  
      Rails.logger.info("Uploaded Image URL: #{uploader.url}")
  
       # ローカル環境ではローカルのパス、本番環境ではS3のURLを返す
      if Rails.env.production?
          uploader.url
      else
          "/uploads/characters/#{uploader.filename}"
      end
     rescue => e
      Rails.logger.error("Image processing or upload failed: #{e.message}")
      nil
    end
  end

  def generate_image_prompt(appearance, type)
    type_description = case type
                       when "モンスター" then "a monster"
                       when "ヒーロー" then "a hero"
                       when "ロボット" then "a robot"
                       else "a character"
                       end
  
    <<~PROMPT
      You are a professional artist. Create a high-quality image of #{type_description} in a Nintendo-inspired style, including a background that complements the character's traits based on the description:
      #{appearance}
    PROMPT
  end
end