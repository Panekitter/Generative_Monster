require_relative "boot"

require "rails/all"
require 'dotenv/load'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Myapp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.i18n.default_locale = :ja

    config.time_zone = 'Tokyo'               # Railsの表示や処理で使うタイムゾーンを日本時間に設定
    config.active_record.default_timezone = :local  # データベースのタイムスタンプをローカルタイム（日本時間）で保存する
  end
end
