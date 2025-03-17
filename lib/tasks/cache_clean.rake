namespace :carrierwave do
  desc "1時間以上前のキャッシュファイルを削除する"
  task clean_cache: :environment do
    CarrierWave.clean_cached_files!(3600)
    puts "Old cached files cleaned"
  end
end