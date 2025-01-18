class DalleService
  def self.generate_image(appearance)
    prompt = <<~PROMPT
      You are a professional artist. Create a high-quality illustration of a character in a Nintendo-inspired style, including a vibrant background that complements the character's traits based on the description:
      #{appearance}
    PROMPT
    puts "DALL·E API Request: #{prompt}" # デバッグ出力
    client = OpenAI::Client.new(access_token: ENV['OPENAI_ACCESS_TOKEN'])
    response = client.images.generate(
      parameters: {
        prompt: prompt,
        size: "256x256",
      }
    )
  
    # デバッグ出力
    puts "DALL·E API Response: #{response.to_h}"
    response.dig("data", 0, "url") # 生成された画像 URL を返す
  end
end
