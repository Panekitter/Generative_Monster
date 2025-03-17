class UserImageUploader < CarrierWave::Uploader::Base
  # 本番環境では S3、それ以外ではローカルに保存
  if Rails.env.production?
    storage :fog
  else
    storage :file
  end

  # 保存先ディレクトリ
  def store_dir
    "uploads/users"
  end

  # WebP形式に変換＆正方形にトリミングする
  process :convert_to_webp

  # ランダムな名前（.webp）を付与
  def filename
    return @name if @name
    @name = "#{SecureRandom.uuid}.webp"
  end

  private

  def convert_to_webp
    cache_stored_file! unless cached?

    tmp_path = File.join(File.dirname(current_path), "tmp_#{SecureRandom.uuid}.webp")

    begin
      vips_image = Vips::Image.new_from_file(current_path)

      # 画像を正方形にトリミング（中心クロップ）
      min_dim = [vips_image.width, vips_image.height].min
      x_offset = (vips_image.width - min_dim) / 2
      y_offset = (vips_image.height - min_dim) / 2
      vips_image = vips_image.crop(x_offset, y_offset, min_dim, min_dim)

      # 縦横どちらかが256を超えている場合のみ、256にリサイズ（正方形なのでどちらも同じ）
      if min_dim > 256
        scale = 256.0 / min_dim
        vips_image = vips_image.resize(scale)
      end

      # WebP に変換 (品質 80)
      vips_image.write_to_file(tmp_path, Q: 80)

      # 元ファイルを削除し、新ファイルに置き換える
      File.delete(current_path) if File.exist?(current_path)
      File.rename(tmp_path, current_path)

    rescue => e
      Rails.logger.error "WebP conversion failed: #{e.message}"
      raise CarrierWave::ProcessingError, "画像の変換に失敗しました。"
    end
  end
end
