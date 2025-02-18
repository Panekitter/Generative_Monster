const puppeteer = require('puppeteer-core');  // puppeteer-coreに変更
const isHeroku = !!process.env.DYNO;  // Heroku環境変数を確認

async function generateCharacterOgImage(characterUrl) {
  const browser = await puppeteer.launch({
    headless: true,
    executablePath: isHeroku ? '/usr/bin/google-chrome-stable' : undefined,  // Heroku環境の場合、Chromeのパスを設定
    args: [
      '--no-sandbox',  // Heroku環境で必須
      '--disable-setuid-sandbox'  // Heroku環境で必須
    ]
  });
  
  const page = await browser.newPage();

  // キャラクター詳細ページにアクセス
  await page.goto(characterUrl, { waitUntil: 'networkidle0' });

  // スクリーンショットを撮影してバッファとして返す
  const imageBuffer = await page.screenshot();

  await browser.close();
  return imageBuffer;
}

// コマンドライン引数からURLを受け取る
const characterUrl = process.argv[2];
generateCharacterOgImage(characterUrl).then((imageBuffer) => {
  process.stdout.write(imageBuffer);
});
