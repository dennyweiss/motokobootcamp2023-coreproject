const defaultTheme = require("tailwindcss/defaultTheme")

module.exports = {
  content: ["./src/**/index.html", "./src/**/*.{vue,js,ts,jsx,tsx}"],
  mode: "jit",
  theme: {
    extend: {
      borderRadius: {
        angularness: "0",
      },
      width: {
        "2/1": "200%",
        70: "17.5rem",
        "116px": "116px",
      },
      height: {
        "2/1": "200%",
        "480px": "480px",
        "72px": "72px",
        "176px": "176px",
        "100px": "100px",
      },
      margin: {
        "-200": "-200%",
        200: "200%",
        "9px": "9px",
        "72px": "72px",
        "4px": "4px",
        "7px": "7px",
      },
      padding: {
        "27px": "27px",
      },
      maxWidth: {
        56: "14rem",
        64: "16rem",
        80: "20rem",
      },
      transitionProperty: {
        size: "height, min-height, width, min-width",
      },
    },
    fontFamily: {
      sans: [
        "Inter",
        "Roboto",
        "system-ui",
        "-apple-system",
        ...defaultTheme.fontFamily.sans,
      ],
    },
    screens: {
      xs: "480px",
      ...defaultTheme.screens,
      "3xl": "1920px",
    },
  },
  plugins: [
    require("@tailwindcss/forms"),
    /* eslint @typescript-eslint/no-var-requires: "off" */
    require("@tailwindcss/typography")({
      modifiers: ["DEFAULT", "lg"],
    }),
    require("@tailwindcss/aspect-ratio"),
    require("@tailwindcss/line-clamp"),
  ],
}
