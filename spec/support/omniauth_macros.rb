module OmniauthMacros
  def mock_auth_google
    # OmniAuth のテストモードを有効にする
    OmniAuth.config.test_mode = true

    # Google OAuth2 のモック認証情報を設定する
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
      provider: 'google_oauth2',
      uid: '123456789',
      info: {
        name: 'Test User',
        email: 'test@example.com'
      },
      credentials: {
        token: 'abcdefg12345',
        refresh_token: 'abcdefg12345',
        expires_at: Time.now + 1.week
      }
    })
  end

  # エラー状態のモックを設定したい場合は以下のようにする
  def mock_auth_failure
    OmniAuth.config.mock_auth[:google_oauth2] = :invalid_credentials
  end
end