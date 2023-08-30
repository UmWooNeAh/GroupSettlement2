module.exports = {
  env: {
    es6: true,
    node: true,
  },
  parserOptions: {
    "sourceType": "module",
    "ecmaVersion": 2018,
  },
  extends: [
    "eslint:recommended",
    "google",
    "prettier",
  ],
  rules: {
    "no-restricted-globals": ["error", "name", "length"],
    "prefer-arrow-callback": "error",
    "quotes": ["error", "double", {"allowTemplateLiterals": true}],
  },
  overrides: [
    {
      files: ["**/*.spec.*"],
      env: {
        mocha: true,
      },
      rules: {},
    },
  ],
  globals: {},
};
