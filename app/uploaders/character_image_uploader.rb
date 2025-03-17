class CharacterImageUploader < CarrierWave::Uploader::Base
  # 本番環境では S3、それ以外ではローカルに保存
  if Rails.env.production?
    storage :fog
  else
    storage :file
  end

  # 保存先ディレクトリ
  def store_dir
    "uploads/characters"
  end

  # WebP形式に変換
  process :convert_to_webp

  # ランダムな名前（.webp）を付与
  def filename
    return @name if @name
    @name = "#{SecureRandom.uuid}.webp"
  end

  def default_url(*args)
    "https://placehold.jp/150x150.png"
  end

  private

  def convert_to_webp
    cache_stored_file! unless cached?
    Rails.logger.info "DEBUG: current_path=#{current_path.inspect}"

    tmp_path = File.join(File.dirname(current_path), "tmp_#{SecureRandom.uuid}.webp")

    begin
      vips_image = Vips::Image.new_from_file(current_path)

      # 縦横どちらかが256を超えている場合のみ、長い方を256にリサイズ
      max_dim = [vips_image.width, vips_image.height].max
      if max_dim > 256
        scale = 256.0 / max_dim
        # アスペクト比を維持したままリサイズ
        vips_image = vips_image.resize(scale)
      end

      # WebP に変換 (品質 80)
      vips_image.write_to_file(tmp_path, Q: 80)

      # 元ファイルを削除し、新ファイルを上書き
      File.delete(current_path) if File.exist?(current_path)
      File.rename(tmp_path, current_path)

    rescue => e
      Rails.logger.error "WebP conversion failed: #{e.message}"
      raise CarrierWave::ProcessingError, "画像の変換に失敗しました。"
    end
  end
end