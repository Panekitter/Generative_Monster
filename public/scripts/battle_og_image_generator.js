const puppeteer = require('puppeteer');

async function generateBattleOgImage(battleUrl) {
  const browser = await puppeteer.launch({ headless: true });
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
