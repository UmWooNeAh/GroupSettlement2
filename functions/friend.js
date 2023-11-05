const functions = require("firebase-functions");
const admin = require("firebase-admin");
const db = admin.firestore();

const { v4 } = require("uuid");
const uuid = () => {
    const tokens = v4().split("-")
    return tokens[2] + tokens[1] + tokens[0] + tokens[3] + tokens[4];
}

exports.sendNtf_requestedFriend  = functions.region("asia-northeast3").firestore
                                .document("userlist/{docId}").onUpdate(async (change, context) => {
    const prev = change.before.data();
    const prevRequested = new Array(prev.requestedfriend);

    const now = change.after.data();
    const nowRequested = new Array(now.requestedfriend);

    try {
          if(prevRequested != nowRequested) {

            const friendRef = db.collection("friendlist").doc(nowRequested[nowRequested.length - 1]);
            const friendDoc = await friendRef.get();

            const alarmTitle = "친구 요청 알림";
            const alarmBody = friendDoc().data.firstusernickname + " 님이 친구 요청을 보냈어요!";
            const alarmId = uuid();

            const message = {
                  notification: {
                      title: alarmTitle,
                      body: alarmBody,
                    },
                    token: now.fcmtoken,
                };

            const alarm = {
                    alarmid: alarmId,
                    title: alarmTitle,
                    body: alarmBody,
                    category: 1
              };

            db.collection("alarmlist").doc(now.serviceuserid)
              .collection("myalarmlist").doc(alarmId).set(alarm);

            admin.messaging().send(message).then((response) => {
                console.log("Successfully sent message:", response);
              })
              .catch((error) => {
                console.log("Error sending message:", error);
              });
          }
    }
    catch (err) {
              console.error(err);
    }

    });
