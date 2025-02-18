const puppeteer = require('puppeteer');

async function generateCharacterOgImage(characterUrl) {
  const browser = await puppeteer.launch({
    headless: true,
    executablePath: '/usr/bin/chromium'  // ※ インストールされた Chromium のパスを指定
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
