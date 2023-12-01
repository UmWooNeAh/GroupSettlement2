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
    const prevRequested = (prev.requestedfriend);

    const now = change.after.data();
    const nowRequested = (now.requestedfriend);

    if(prevRequested.length < nowRequested.length) {
        console.log("길이 비교: " + prevRequested.length + "->" +  nowRequested.length);
        try {
                const friendid = nowRequested[nowRequested.length - 1];
                console.log("아이디 값: " + friendid);
                const friendRef = db.collection("friendlist").doc(friendid);
                const friendDoc = await friendRef.get();

                const alarmTitle = "친구 요청 알림";
                const alarmBody = friendDoc.data().usernickname + " 님이 친구 요청을 보냈어요!";
                const alarmId = uuid();

                const message = {
                      notification: {
                          title: alarmTitle,
                          body: alarmBody,
                        },
                        data: {
                            route: "/MyPage",
                            topic: "RequestFriend",
                        },
                        token: now.fcmtoken,
                    };

                const alarm = {
                        alarmid: alarmId,
                        title: alarmTitle,
                        body: alarmBody,
                        category: 1,
                        route: "/MyPage",
                        isread: false,
                        time: admin.firestore.Timestamp.fromDate(new Date())
                  };
                const alarmDoc = await db.collection("alarmlist").doc(friendDoc.data().serviceuserid)
                .collection("myalarmlist").get();
                const alarmCnt = alarmDoc.size;
                console.log("알림 수: ", alarmCnt);
                if(alarmCnt > 60) {
                   const collectionRef = db.collection("alarmlist").doc(friendDoc.data().serviceuserid)
                      .collection("myalarmlist").orderBy("time").limit(1);
                   const collectionsnapshot = await collectionRef.get();
                   const oldestDoc = collectionsnapshot.docs[0];
                   const oldestid = oldestDoc.data().alarmid;
                   await  db.collection("alarmlist").doc(friendDoc.data().serviceuserid)
                          .collection("myalarmlist").doc(oldestid).delete();
                }
                db.collection("alarmlist").doc(now.serviceuserid)
                  .collection("myalarmlist").doc(alarmId).set(alarm);

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

exports.sendNtf_acceptFriend  = functions.region("asia-northeast3").firestore
                                .document("userlist/{docId}").onUpdate(async (change, context) => {
    const prev = change.before.data();
    const prevFriend = prev.friends;
    const prevAccepted = prev.requestedfriend;

    const now = change.after.data();
    const nowFriend = now.friends;
    const nowAccepted = now.requestedfriend;

    if(prevFriend.length < nowFriend.length) {
        try {
             for (let i = prevFriend.length; i < nowFriend.length; i++) {
                const otherfid = nowFriend[i];
                  if(prevAccepted != nowAccepted) { // 친구 요청 수락한 사람
                      const otherFriendRef = db.collection("friendlist").doc(otherfid);
                      const otherFriendDoc = await otherFriendRef.get();

                      const alarmTitle = "친구 수락 알림";
                      const alarmBody = otherFriendDoc.data().usernickname + " 님과 친구가 되었어요!";
                      const alarmId = uuid();

                      const message = {
                            notification: {
                                title: alarmTitle,
                                body: alarmBody,
                              },
                              data: {
                                route: "/MyPage",
                                topic: "AcceptFriend",
                              },
                              token: now.fcmtoken,
                          };

                      const alarm = {
                              alarmid: alarmId,
                              title: alarmTitle,
                              body: alarmBody,
                              category: 1,
                              route: "/MyPage",
                              isread: false,
                              time: admin.firestore.Timestamp.fromDate(new Date())
                        };
                      const alarmDoc = await db.collection("alarmlist").doc(otherFriendDoc.data().serviceuserid)
                      .collection("myalarmlist").get();
                      const alarmCnt = alarmDoc.size;
                      console.log("알림 수: ", alarmCnt);
                      if(alarmCnt > 60) {
                         const collectionRef = db.collection("alarmlist").doc(otherFriendDoc.data().serviceuserid)
                            .collection("myalarmlist").orderBy("time").limit(1);
                         const collectionsnapshot = await collectionRef.get();
                         const oldestDoc = collectionsnapshot.docs[0];
                         const oldestid = oldestDoc.data().alarmid;
                         await  db.collection("alarmlist").doc(otherFriendDoc.data().serviceuserid)
                                .collection("myalarmlist").doc(oldestid).delete();
                      }
                      db.collection("alarmlist").doc(now.serviceuserid)
                        .collection("myalarmlist").doc(alarmId).set(alarm);

                      admin.messaging().send(message).then((response) => {
                          console.log("Successfully sent message:", response);
                        })
                        .catch((error) => {
                          console.log("Error sending message:", error);
                        });
                  }
                  else { // 친구 요청 보낸 사람
                          const otherFriendRef = db.collection("friendlist").doc(otherfid);
                          const otherFriendDoc = await otherFriendRef.get();

                          const alarmTitle = "친구 요청 수락 알림";
                          const alarmBody = otherFriendDoc.data().usernickname + " 님이 친구 요청을 수락하였어요!";
                          const alarmId = uuid();

                          const message = {
                                notification: {
                                    title: alarmTitle,
                                    body: alarmBody,
                                  },
                                  data: {
                                    route: "/MyPage",
                                    topic: "AcceptFriend",
                                    },
                                  token: now.fcmtoken,
                              };

                          const alarm = {
                                  alarmid: alarmId,
                                  title: alarmTitle,
                                  body: alarmBody,
                                  category: 1,
                                  route: "/MyPage",
                                  isread: false,
                                  time: admin.firestore.Timestamp.fromDate(new Date())
                            };
                          const alarmDoc = await db.collection("alarmlist").doc(otherFriendDoc.data().serviceuserid)
                          .collection("myalarmlist").get();
                          const alarmCnt = alarmDoc.size;
                          console.log("알림 수: ", alarmCnt);
                          if(alarmCnt > 60) {
                             const collectionRef = db.collection("alarmlist").doc(otherFriendDoc.data().serviceuserid)
                                .collection("myalarmlist").orderBy("time").limit(1);
                             const collectionsnapshot = await collectionRef.get();
                             const oldestDoc = collectionsnapshot.docs[0];
                             const oldestid = oldestDoc.data().alarmid;
                             await  db.collection("alarmlist").doc(otherFriendDoc.data().serviceuserid)
                                    .collection("myalarmlist").doc(oldestid).delete();
                          }
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
            }
        catch (err) {
                  console.error(err);
        }

    }
});
