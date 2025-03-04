require 'httparty'

class NebiusFluxService
  NEBIUS_API_URL = 'https://api.studio.nebius.ai/v1/images/generations'.freeze
  NEBIUS_API_KEY = ENV['NEBIUS_ACCESS_TOKEN']  # .envに設定したAPIキー

  def self.generate_image(prompt)
    puts "Nebius Flux API Request: #{prompt}" # デバッグ出力
    # APIリクエストボディを組み立て
    body = {
      model: 'black-forest-labs/flux-schnell',
      prompt: prompt,
      response_format: 'url',             # 画像URLでの応答を要求&#8203;:contentReference[oaicite:13]{index=13}
      response_extension: 'webp',         # 生成画像形式（WebP）&#8203;:contentReference[oaicite:14]{index=14}
      width: 512,                         # 幅512pxで生成&#8203;:contentReference[oaicite:15]{index=15}
      height: 512,                        # 高さ512px&#8203;:contentReference[oaicite:16]{index=16}
      num_inference_steps: 4,             # 4ステップで高速生成&#8203;:contentReference[oaicite:17]{index=17}
      negative_prompt: '',               # 負のプロンプトなし（必要に応じて設定）
      seed: -1                            # シード値-1（ランダム）&#8203;:contentReference[oaicite:18]{index=18}
    }

    # HTTPartyでPOSTリクエスト送信
    response = HTTParty.post(
      NEBIUS_API_URL,
      headers: {
        'Content-Type' => 'application/json',
        'Authorization' => "Bearer #{NEBIUS_API_KEY}"
      },
      body: body.to_json
    )

    # レスポンスから画像URLを取り出す
    result = JSON.parse(response.body)
    image_url = result.dig('data', 0, 'url')
    return image_url  # 取得した画像URLを返す
  end
end
