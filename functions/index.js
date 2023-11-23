const admin = require("firebase-admin");

admin.initializeApp();

exports.group = require("./group");
exports.settlement = require("./settlement");
exports.friend = require("./friend");
