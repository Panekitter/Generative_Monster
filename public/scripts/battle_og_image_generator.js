const puppeteer = require('puppeteer-core');

const isHeroku = !!process.env.DYNO;  // Heroku環境変数を確認

async function generateBattleOgImage(battleUrl) {
  const browser = await puppeteer.launch({
    headless: true,
    executablePath: isHeroku ? '/app/.chrome-for-testing/chrome-linux64/chrome' : '/usr/bin/chromium', // Heroku環境に応じたパスを指定
    args: [
      '--no-sandbox',            // Heroku環境で必須
      '--disable-setuid-sandbox' // Heroku環境で必須
    ]
  });

  const page = await browser.newPage();

  // 1200x630 のビューポートを設定
  await page.setViewport({ width: 1200, height: 630 });

  // 戦闘結果ページにアクセス
  await page.goto(battleUrl, { waitUntil: 'networkidle0' });

  // 1200x630 の範囲でスクリーンショットを撮影
  const imageBuffer = await page.screenshot({
    clip: { x: 0, y: 0, width: 1200, height: 630 },
    type: 'png'
  });

  await browser.close();
  return imageBuffer;
}

// コマンドライン引数から戦闘結果ページのURLを受け取る
const battleUrl = process.argv[2];
generateBattleOgImage(battleUrl).then((imageBuffer) => {
  process.stdout.write(imageBuffer);
});
