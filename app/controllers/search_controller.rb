class SearchController < ApplicationController
  def index
    query = params[:q]
    category = params[:category]
    kana_from = 'アイウエオカキクケコガギグゲゴサシスセソザジズゼゾタチツテトダヂヅデドナニヌネノハヒフヘホバビブベボパピプペポマミムメモヤユヨラリルレロワヲンァィゥェォッャュョ'
    kana_to   = 'あいうえおかきくけこがぎぐげござしすせそざじずぜぞたちつてとだぢづでどなにぬねのはひふへほばびぶべぼぱぴぷぺぽまみむめもやゆよらりるれろわをんぁぃぅぇぉっゃゅょ'
    

    results = case category
              when "users"
                User
                  .where("translate(name, ?, ?) LIKE '%' || translate(?, ?, ?) || '%'",
                        kana_from, kana_to, query, kana_from, kana_to)
                  .limit(10)
                  .map do |user|
                    {
                      id: user.id,
                      name: user.name,
                      url: user_path(user),
                      image_url: user.image? ? user.image.url : nil
                    }
                  end
              when "characters"  # グローバルなキャラクター検索
                Character
                  .where("translate(name, ?, ?) LIKE '%' || translate(?, ?, ?) || '%'",
                         kana_from, kana_to, query, kana_from, kana_to)
                  .limit(10)
                  .map do |char|
                    {
                      id: char.id,
                      name: char.name,
                      url: character_path(char),
                      image_url: char.image? ? char.image.url : nil
                    }
                  end
              when "user_characters"  # ユーザー専用のキャラクター検索
                user_id = params[:user_id]
                Character
                  .where("translate(name, ?, ?) LIKE '%' || translate(?, ?, ?) || '%'",
                         kana_from, kana_to, query, kana_from, kana_to)
                  .where(user_id: user_id)
                  .limit(10)
                  .map do |char|
                    {
                      id: char.id,
                      name: char.name,
                      url: character_path(char),
                      image_url: char.image? ? char.image.url : nil
                    }
                  end
              when "battles"
                Battle
                  .where("
                    translate(character_1_name, ?, ?) LIKE '%' || translate(?, ?, ?) || '%'
                    OR translate(character_2_name, ?, ?) LIKE '%' || translate(?, ?, ?) || '%'
                  ",
                  kana_from, kana_to, query, kana_from, kana_to,
                  kana_from, kana_to, query, kana_from, kana_to)
                  .limit(10)
                  .map do |battle|
                    {
                      id: battle.id,
                      name: "#{battle.created_at} #{battle.character_1_name} vs #{battle.character_2_name}",
                      url: battle_path(battle),
                      image_url: nil
                    }
                  end
              when "user_battles"
                user_id = params[:user_id]
                Battle
                  .where("
                    (translate(character_1_name, ?, ?) LIKE '%' || translate(?, ?, ?) || '%'
                      OR translate(character_2_name, ?, ?) LIKE '%' || translate(?, ?, ?) || '%')
                      AND user_id = ?
                  ",
                  kana_from, kana_to, query, kana_from, kana_to,
                  kana_from, kana_to, query, kana_from, kana_to,
                  user_id)
                  .limit(10)
                  .map do |battle|
                    {
                      id: battle.id,
                      name: "#{battle.created_at} #{battle.character_1_name} vs #{battle.character_2_name}",
                      url: battle_path(battle),
                      image_url: nil
                    }
                  end
              else
                []
              end

    render json: results
  end
end
