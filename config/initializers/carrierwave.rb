CarrierWave.configure do |config|
  if Rails.env.production?
    config.fog_provider = 'fog/aws'
    config.fog_credentials = {
      provider:              'AWS',
      aws_access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
      region:                ENV['AWS_REGION']
    }
    config.fog_directory  = ENV['AWS_S3_BUCKET']
    config.fog_public     = true
    config.fog_attributes = { 'Cache-Control' => "max-age=315576000" } # ACLを明示的に指定しない
    config.cache_storage  = :fog
    config.remove_previously_stored_files_after_update = true
  else
    config.storage = :file
    config.root = Rails.root.join("public") # ローカル保存用のパス
  end
end
