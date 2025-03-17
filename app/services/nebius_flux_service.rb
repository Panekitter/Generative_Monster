require 'httparty'

class NebiusFluxService
  NEBIUS_API_URL = 'https://api.studio.nebius.ai/v1/images/generations'.freeze
  NEBIUS_API_KEY = ENV['NEBIUS_ACCESS_TOKEN']  # .envに設定したAPIキー

  def self.generate_image(prompt)
    puts "Nebius Flux API Request: #{prompt}" # デバッグ出力
  
    body = {
      model: 'black-forest-labs/flux-schnell',
      prompt: prompt,
      response_format: 'url',
      response_extension: 'webp',
      width: 512,
      height: 512,
      num_inference_steps: 4,
      negative_prompt: '',
      seed: -1
    }
  
    begin
      response = HTTParty.post(
        NEBIUS_API_URL,
        headers: {
          'Content-Type' => 'application/json',
          'Authorization' => "Bearer #{NEBIUS_API_KEY}"
        },
        body: body.to_json
      )
  
      unless response.success?
        Rails.logger.error("NebiusFluxService API Error: HTTP #{response.code} - #{response.body}")
        return nil
      end
  
      result = JSON.parse(response.body)  # ここで JSON::ParserError になる可能性
      image_url = result.dig('data', 0, 'url')
      return image_url
    rescue JSON::ParserError => e
      Rails.logger.error("NebiusFluxService JSON Parse Error: #{e.message}")
      return nil
    rescue => e
      # ネットワークエラー等をキャッチ
      Rails.logger.error("NebiusFluxService Request Failed: #{e.message}")
      return nil
    end
  end
end
