module.exports = {
  root: true,
  env: {
    es6: true,
    node: true,
  },
  extends: [
    "eslint:recommended",
    "plugin:import/errors",
    "plugin:import/warnings",
    "plugin:import/typescript",
    "google",
    "plugin:@typescript-eslint/recommended",
    "prettier",
  ],
  parser: "@typescript-eslint/parser",
  parserOptions: {
    project: ["tsconfig.json", "tsconfig.dev.json"],
    sourceType: "module",
  },
  ignorePatterns: [
    "/lib/**/*", // Ignore built files.
  ],
  plugins: [
    "@typescript-eslint",
    "import",
  ],
  rules: {
    "quotes": ["error", "double"],
    "import/no-unresolved": 0,
    "indent": "off",
    "camelcase": ["error", {"allow": ["sendNtf_requestedFriend", "sendNtf_acceptFriend", "sendNtf_CreateGroup", "sendNtf_CreateSettlement", "sendNtf_SendSettlementPaper",
    "sendNtf_CheckSent", "sendNtf_finishSettlement"]}],
    "@typescript-eslint/no-explicit-any": ["off"],
  },
};
