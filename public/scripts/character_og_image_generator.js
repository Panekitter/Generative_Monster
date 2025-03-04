const puppeteer = require('puppeteer-core');

const isHeroku = !!process.env.DYNO; // Heroku環境変数を確認

async function generateCharacterOgImage(characterUrl) {
  const browser = await puppeteer.launch({
    headless: true,
    executablePath: isHeroku ? '/app/.chrome-for-testing/chrome-linux64/chrome' : '/usr/bin/chromium', // Heroku環境に応じたパスを指定
    args: [
      '--no-sandbox',  // Heroku環境で必須
      '--disable-setuid-sandbox'  // Heroku環境で必須
    ]
  });

  const page = await browser.newPage();

  // ✅ ここで 1200x630 のサイズを指定
  await page.setViewport({ width: 1200, height: 630 });

  // キャラクター詳細ページにアクセス
  await page.goto(characterUrl, { waitUntil: 'networkidle0' });

  // ✅ スクリーンショットのサイズを 1200x630 に固定
  const imageBuffer = await page.screenshot({
    clip: { x: 0, y: 0, width: 1200, height: 630 },
    type: 'png'
  });

  await browser.close();
  return imageBuffer;
}

// コマンドライン引数からURLを受け取る
const characterUrl = process.argv[2];
generateCharacterOgImage(characterUrl).then((imageBuffer) => {
  process.stdout.write(imageBuffer);
});
