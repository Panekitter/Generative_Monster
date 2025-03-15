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
end