require 'httparty'

class CreateBattleService
  NEBIUS_API_URL = 'https://api.studio.nebius.com/v1/chat/completions'.freeze
  NEBIUS_API_KEY = ENV['NEBIUS_ACCESS_TOKEN']  # .envに設定したAPIキー
  
  def matchmake(user_character, other_users_characters)
    opponent = other_users_characters.sample
    { user_character: user_character, opponent: opponent }
  end

  def generate_battle_result(character_a, character_b)
    prompt = <<~PROMPT
      キャラA
      #{character_a.to_json}

      キャラB
      #{character_b.to_json}

      この2体のキャラクターを戦わせ、result, eventを必ずJSON形式のみで返してください。
      これらはすべて必須項目です。
      キャラAについては選択されたスキル「#{character_a[:skill][:name]}」のみを使用してください。
      キャラBについては選択されたスキル「#{character_b[:skill][:name]}」のみを使用してください。
      resultは勝ったキャラを「A」または「B」として返してください。
      eventは戦闘中のストーリーを、物語形式で600~1000文字の文章で日本語で書いてください。
      例:
      {
        "result": "A",
        "event": "戦闘結果の文章"
      }
    PROMPT

    puts "Create Battle Prompt: #{prompt}" # デバッグ出力

    # 1. バトル内容に応じたプロンプトメッセージを構築（例としてsystemとuserロールを使用）
    messages = [
      { role: "system", content: "あなたは戦闘シミュレーターAIです。与えられた戦闘データに基づき、勝者を決定し戦闘の詳細なストーリーをJSONで出力してください。" },
      { role: "user", content: prompt }
    ]

    # 2. Nebius AI StudioのDeepSeek-R1モデルにリクエストを送信
    response = HTTParty.post(
      NEBIUS_API_URL,
      headers: {
        'Content-Type' => 'application/json',
        'Authorization' => "Bearer #{NEBIUS_API_KEY}"
      },
      body: {
        model:       "deepseek-ai/DeepSeek-R1",
        messages:    messages,
        max_tokens:  8192,
        temperature: 0.6,
        top_p:       0.95,
        response_format: { type: 'json_object' }
      }.to_json,
      timeout: 180
    )

    # 3. レスポンスからAIの返答を取得（OpenAI互換のレスポンス形式）
    # Nebius APIのレスポンスは OpenAI と同様、choices配列にメッセージが含まれる
    result = response.dig("choices", 0, "message", "content")

    puts "Create Deepseek Battle Result: #{result}" # デバッグ出力

    think_end = result.index('</think>')
    if think_end
      json_start = result.index('{', think_end)
    else
      json_start = result.index('{')
    end

    if json_start.nil?
      raise "応答からJSON部分が見つかりませんでした"
    end

    json_text = result[json_start..-1]
    json_text.gsub(/```/, '')  # コードブロックの ``` を削除
    json_text.strip!
    json_text

    puts "Create Battle JSON: #{json_text}" # デバッグ出力


    # 4. AIの返答（JSON文字列）をパースして、result（勝敗）とevent（ストーリー）を取得
    begin
      result_json = JSON.parse(json_text)  # AIが返すコンテンツはJSON形式を想定
    rescue JSON::ParserError => e
      raise "AIからの応答がJSON形式ではありません: #{e.message}"
    end

    return result_json

    rescue Net::ReadTimeout => e
      Rails.logger.error("Nebius API タイムアウトエラー: #{e.message}")
      raise "戦闘結果の生成に時間がかかりすぎています。再試行してください。"
    rescue StandardError => e
      Rails.logger.error("戦闘結果生成エラー: #{e.message}")
      raise "戦闘結果の生成に失敗しました"
  end
end
