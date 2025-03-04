require 'openai'

class CreateBattleService
  def initialize
    @client = OpenAI::Client.new(access_token: ENV['OPENAI_ACCESS_TOKEN'])
  end

  def matchmake(user_character, other_users_characters)
    opponent = other_users_characters.sample
    { user_character: user_character, opponent: opponent }
  end

  # 戦闘結果を生成
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

    response = @client.chat(
      parameters: {
        model: "gpt-4o-mini",
        messages: [
          { role: "system", content: "あなたは戦闘シミュレーターAIです。与えられた戦闘データに基づき、勝者を決定し戦闘の詳細なストーリーをJSONで出力してください。" },
          { role: "user", content: prompt }
        ],
        response_format: { "type": "json_object" },
        temperature: 0.7,
        max_tokens: 1500
      }
    )

    puts "Create 4o mini Battle Response: #{response}" # デバッグ出力

    result = response.dig("choices", 0, "message", "content")
    JSON.parse(result)
  rescue JSON::ParserError => e
    raise "AIからの応答がJSON形式ではありません: #{e.message}"
  end
end
