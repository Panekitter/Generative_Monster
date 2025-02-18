FROM ruby:3.2.2

# 必要なパッケージのインストール
RUN apt-get update -qq \
 && apt-get install -y nodejs postgresql-client npm vim chromium fonts-noto-cjk \
 && rm -rf /var/lib/apt/lists/* \
 && npm install --global yarn

# UIDとGIDを環境変数から受け取る
ARG UID=1000
ARG GID=1000

# ユーザーとグループの作成
RUN groupadd -g $GID appgroup && \
    useradd -m -u $UID -g appgroup appuser

# 作業ディレクトリの作成
RUN mkdir /myapp
WORKDIR /myapp

# ユーザー権限の設定
RUN chown -R appuser:appgroup /myapp

# Gem環境の設定
ENV GEM_HOME=/myapp/.gem
ENV PATH=$GEM_HOME/bin:$PATH

# foremanのインストール
RUN gem install foreman

# GemfileとGemfile.lockをコピー
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock

# bundle installの実行
RUN bundle install

# アプリケーションコードをコピー
ADD . /myapp

# entrypoint.shのコピーと実行権限の付与
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

# 非rootユーザーに切り替え
USER appuser

# Chromeのパスを環境変数として設定
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium

# ポートの公開
EXPOSE 3000

# サーバーの起動
CMD ["rails", "server", "-b", "0.0.0.0"]
