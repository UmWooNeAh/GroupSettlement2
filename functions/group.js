const functions = require("firebase-functions");
const admin = require("firebase-admin");
const db = admin.firestore();

const { v4 } = require("uuid");
const uuid = () => {
    const tokens = v4().split("-")
    return tokens[2] + tokens[1] + tokens[0] + tokens[3] + tokens[4];
}

exports.sendNtf_CreateGroup  = functions.region("asia-northeast3").firestore
                                .document("grouplist/{docId}").onCreate(async (snap, context) => {
    const newvalue = snap.data();

    try {
          for(const user of newvalue.serviceusers) {
            const userRef = db.collection("userlist").doc(user);
            const userDoc = await userRef.get();

            const alarmTitle = "그룹 생성 알림";
            const alarmBody = newvalue.groupname + " 그룹이 생성되었어요! 그룹에 소속된 사람들을 살펴보세요.";
            const alarmId = uuid();

            const message = {
              notification: {
                  title: alarmTitle,
                  body: alarmBody,
                },
                token: userDoc.data().fcmtoken,
            };
            const alarm = {
                alarmid: alarmId,
                title: alarmTitle,
                body: alarmBody,
                category: 2
            };

            db.collection("alarmlist").doc(userDoc.data().serviceuserid)
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
