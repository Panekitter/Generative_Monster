const puppeteer = require('puppeteer-core');

const isHeroku = !!process.env.DYNO;  // Heroku環境変数を確認

async function generateBattleOgImage(battleUrl) {
  const browser = await puppeteer.launch({
    headless: true,
    executablePath: isHeroku ? '/app/.chrome-for-testing/chrome-linux64/chrome' : '/usr/bin/chromium', // Heroku環境に応じたパスを指定
    args: [
      '--no-sandbox',  // Heroku環境で必須
      '--disable-setuid-sandbox'  // Heroku環境で必須
    ]
  });

  const page = await browser.newPage();

  // 戦闘結果ページにアクセス
  await page.goto(battleUrl, { waitUntil: 'networkidle0' });

  // スクリーンショットを撮影してバッファとして返す
  const imageBuffer = await page.screenshot();

  await browser.close();

  return imageBuffer;
}

// コマンドライン引数からURLを受け取る
const battleUrl = process.argv[2]; // 戦闘結果ページのURL
generateBattleOgImage(battleUrl).then((imageBuffer) => {
  // 標準出力に画像バッファを出力
  process.stdout.write(imageBuffer);
});
