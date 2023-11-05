const admin = require("firebase-admin");

admin.initializeApp();

exports.group = require("./group");
exports.settlement = require("./settlement");
exports.friend = require("./friend");

/*
exports.sendNotification = functions.region("asia-northeast3").firestore
.document("userlist/{docId}").onUpdate(async (change, context) => {

    const prev = change.before.data();
    const now = change.after.data();

    if (prev.name != now.name) {
        try {
            const message = {
                notification: {
                    title: "회원 이름 변경 알림",
                    body: prev.name + " 회원님의 이름이 " + now.name + " 으로 변경되었어요! 지금 확인해보세요.",
                  },
                  token: now.fcmtoken,
            };
            admin.messaging().send(message).then((response) => {
                  console.log("Successfully sent message:", response);
                })
                .catch((error) => {
                  console.log("Error sending message:", error);
                });
        }
        catch (err) {
                console.error(err);
        }
    }
  });
  */