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
      キャラAについては選択されたスキル「#{character_a['skill']}」のみを使用してください。
      キャラBについては選択されたスキル「#{character_b['skill']}」のみを使用してください。
      resultは勝ったキャラのname_of_characterを返してください。
      eventは戦闘中のストーリーを、物語形式で300～600文字の文章で日本語で書いてください。
    PROMPT

    response = @client.chat(
      parameters: {
        model: "gpt-4o-mini",
        messages: [
          { role: "system", content: "あなたはプロのゲームマスターです。" },
          { role: "user", content: prompt }
        ],
        response_format: { "type": "json_object" },
        temperature: 0.7,
        max_tokens: 1500
      }
    )

    result = response.dig("choices", 0, "message", "content")
    JSON.parse(result)
  rescue JSON::ParserError => e
    raise "AIからの応答がJSON形式ではありません: #{e.message}"
  end
end
