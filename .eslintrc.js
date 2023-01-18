module.exports = {
  root: true,
  parser: "vue-eslint-parser",
  parserOptions: {
    parser: {
      // Script parser for `<script>`
      js: "espree",
      // Script parser for `<script lang="ts">`
      ts: "@typescript-eslint/parser",
      // Script parser for vue directives (e.g. `v-if=` or `:attribute=`)
      // and vue interpolations (e.g. `{{variable}}`).
      // If not specified, the parser determined by `<script lang ="...">` is used.
      "<template>": "espree",
    },
  },
  env: {
    browser: true,
    es2020: true,
    node: true,
  },
  extends: [
    "eslint:recommended",
    "plugin:@typescript-eslint/eslint-recommended",
    "plugin:@typescript-eslint/recommended",
    "plugin:vue/vue3-recommended",
    "plugin:yaml/recommended",
    "prettier",
  ],
  plugins: ["yaml"],
  rules: {
    "no-console": process.env.NODE_ENV === "production" ? "error" : "warn",
    "no-debugger": process.env.NODE_ENV === "production" ? "error" : "warn",
    "vue/no-unused-vars": "error",
    "vue/script-setup-uses-vars": "error",
    "vue/component-tags-order": [
      "error",
      {
        order: ["template", "script", "style"],
      },
    ],
    "vue/no-v-html": process.env.NODE_ENV === "production" ? "warn" : "off",
    "vue/comment-directive": [
      "error",
      {
        reportUnusedDisableDirectives: false,
      },
    ],
    "vue/html-indent": "off",
  },
}
