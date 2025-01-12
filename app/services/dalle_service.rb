class DalleService
  def self.generate_image(appearance)
    prompt = <<~PROMPT
      あなたはプロのアーティストです。以下の特徴に基づいて、キャラクターの高品質なデジタルイラストを、アメコミ風のスタイルで描いてください：
      #{appearance}
    PROMPT
    puts "DALL·E API Request: #{prompt}" # デバッグ出力
    client = OpenAI::Client.new(access_token: ENV['OPENAI_ACCESS_TOKEN'])
    response = client.images.generate(
      parameters: {
        prompt: prompt,
        model: "dall-e-3",
        size: "1024x1024",
        quality: "standard",
        n: 1
      }
    )
  
    # デバッグ出力
    puts "DALL·E API Response: #{response.to_h}"
    response.dig("data", 0, "url") # 生成された画像 URL を返す
  end
end
