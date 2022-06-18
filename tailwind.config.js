const defaultTheme = require("tailwindcss/defaultTheme")

module.exports = {
  content: ["index.html", "src/**/*.elm"],
  theme: {
    extend: {
      fontFamily: {
        sans: ["Work sans", ...defaultTheme.fontFamily.sans],
      },
    },
  },
  plugins: [],
}
