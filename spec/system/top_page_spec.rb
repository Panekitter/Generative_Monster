require 'rails_helper'

RSpec.describe "TopPage", type: :request do
  include OmniauthMacros

  it "ログイン前にトップページにアクセスできる" do
    get root_path
    expect(response.body).to include("※利用にはGoogleアカウントへのログインが必要です")
  end

  it "ログイン後にトップページにアクセスできない" do
    mock_auth_google

    get '/auth/google_oauth2/callback'
    get root_path
    expect(response.body).to_not include("※利用にはGoogleアカウントへのログインが必要です")
  end

  it "ログイン前はダッシュボードページにアクセスできない" do
    get dashboard_path
    expect(response.body).to_not include("あなたのアイデアを入力して、オリジナルキャラクターを生成しよう！")
  end

  it "ログイン後にダッシュボードページにアクセスできる" do
    mock_auth_google

    get '/auth/google_oauth2/callback'
    get dashboard_path
    expect(response.body).to include("あなたのアイデアを入力して、オリジナルキャラクターを生成しよう！")
  end
end