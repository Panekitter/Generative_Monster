const express = require('express');
const path = require('path');

const app = express();
const port = process.env.PORT || 3000;

// 静的ファイルを提供
app.use(express.static(path.join(__dirname, 'public')));

app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

// サーバー起動
app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});
