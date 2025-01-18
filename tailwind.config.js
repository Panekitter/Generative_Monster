module.exports = {
  content: [
    './app/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*',
  ],
  theme: {
    extend: {
      fontFamily: {
        logo: ['Orbitron', 'sans-serif'],
      },
    },
  },
  plugins: [require('daisyui')],
  daisyui: {
    themes: ["retro", "bumblebee"], // 必要なテーマをここに列挙
  },
};
