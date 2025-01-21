class DalleService
  def self.generate_image(appearance_prompt)
    puts "DALL·E API Request: #{appearance_prompt}" # デバッグ出力
    client = OpenAI::Client.new(access_token: ENV['OPENAI_ACCESS_TOKEN'])
  
    begin
      response = client.images.generate(
        parameters: {
          prompt: appearance_prompt,
          size: "256x256",
        }
      )
  
      # デバッグ出力
      puts "DALL·E API Response: #{response.to_h}"
      response.dig("data", 0, "url") # 生成された画像 URL を返す
    rescue OpenAI::Error => e
      Rails.logger.error("DALL·E APIエラー: #{e.message}")
      raise "画像生成に失敗しました"
    rescue StandardError => e
      Rails.logger.error("予期しないエラーが発生しました: #{e.message}")
      raise "画像生成に失敗しました"
    end
  end

  private

  
end
