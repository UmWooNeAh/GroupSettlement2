const functions = require("firebase-functions");
const admin = require("firebase-admin");
const db = admin.firestore();

const { v4 } = require("uuid");
const uuid = () => {
    const tokens = v4().split("-")
    return tokens[2] + tokens[1] + tokens[0] + tokens[3] + tokens[4];
}

exports.sendNtf_CreateSettlement  = functions.region("asia-northeast3").firestore
                            .document("settlementlist/{docId}").onCreate(async (snap, context) => {
    const newvalue = snap.data();
    const settlmentGroup = newvalue.groupid;

    const masterid = newvalue.masteruserid;
    const masterRef = db.collection("userlist").doc(masterid);
    const masterDoc = await masterRef.get();
    const master = masterDoc.data().name;

    try {
      const groupRef = db.collection("grouplist").doc(settlmentGroup);
      const groupDoc = await groupRef.get();
      const serviceusers = groupDoc.data().serviceusers;

      for(const userid of serviceusers) {
        if(userid == masterid) {

            const alarmTitle = "정산 생성 알림";
            const alarmBody = newvalue.settlementname + " 정산을 성공적으로 생성하였어요.";
            const alarmId = uuid();

            const message = {
              notification: {
                  title: alarmTitle,
                  body: alarmBody,
                },
                data: {
                  route: "/SettlementInformation",
                  topic: "SettlementCreate",
                  arg0: newvalue.settlementid,
                  arg1: newvalue.groupid,
                  arg2: userid,
                },
                token: masterDoc.data().fcmtoken,
            };
            const alarm = {
                alarmid: alarmId,
                title: alarmTitle,
                body: alarmBody,
                category: 1,
                route: "/SettlementInformation",
                args: [
                    newvalue.settlementid,
                    newvalue.groupid,
                ],
                isread: false,
                time: admin.firestore.Timestamp.fromDate(new Date())
            };

            const alarmDoc = await db.collection("alarmlist").doc(masterDoc.data().serviceuserid)
            .collection("myalarmlist").get();
            const alarmCnt = alarmDoc.size;
            console.log("알림 수: ", alarmCnt);
            if(alarmCnt > 60) {
               const collectionRef = db.collection("alarmlist").doc(masterDoc.data().serviceuserid)
                  .collection("myalarmlist").orderBy("time").limit(1);
               const collectionsnapshot = await collectionRef.get();
               const oldestDoc = collectionsnapshot.docs[0];
               const oldestid = oldestDoc.data().alarmid;
               await  db.collection("alarmlist").doc(masterDoc.data().serviceuserid)
                      .collection("myalarmlist").doc(oldestid).delete();
            }

            db.collection("alarmlist").doc(masterDoc.data().serviceuserid)
                    .collection("myalarmlist").doc(alarmId).set(alarm);

            admin.messaging().send(message).then((response) => {
                console.log("Successfully sent message:", response);
              })
              .catch((error) => {
                console.log("Error sending message:", error);
              });
        }
        else {
        const userRef = db.collection("userlist").doc(userid);
        const userDoc = await userRef.get();

        const alarmTitle = "정산 생성 알림";
        const alarmBody = master + " 님이 생성한 " + newvalue.settlementname + " 정산을 확인해보세요.";
        const alarmId = uuid();

        const message = {
          notification: {
              title: alarmTitle,
              body: alarmBody,
            },
            data: {
                route: "/SettlementInformation",
                topic: "SettlementCreate",
                arg0: newvalue.settlementid,
                arg1: newvalue.groupid,
                arg2: userid,
            },
            token: userDoc.data().fcmtoken,
        };
        const alarm = {
            alarmid: alarmId,
            title: alarmTitle,
            body: alarmBody,
            category: 1,
            route: "/SettlementInformation",
            args: [
                newvalue.settlementid,
                newvalue.groupid,
                userid,
            ],
            isread: false,
            time: admin.firestore.Timestamp.fromDate(new Date())
        };
        const alarmDoc = await db.collection("alarmlist").doc(userDoc.data().serviceuserid)
        .collection("myalarmlist").get();
        const alarmCnt = alarmDoc.size;
        console.log("알림 수: ", alarmCnt);
        if(alarmCnt > 60) {
           const collectionRef = db.collection("alarmlist").doc(userDoc.data().serviceuserid)
              .collection("myalarmlist").orderBy("time").limit(1);
           const collectionsnapshot = await collectionRef.get();
           const oldestDoc = collectionsnapshot.docs[0];
           const oldestid = oldestDoc.data().alarmid;
           await  db.collection("alarmlist").doc(userDoc.data().serviceuserid)
                  .collection("myalarmlist").doc(oldestid).delete();
        }
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
    }
    catch (err) {
              console.error(err);
    }

});

exports.sendNtf_SendSettlementPaper  = functions.region("asia-northeast3").firestore
                            .document("settlementpaperlist/{docId}").onCreate(async (snap, context) => {
    const newvalue = snap.data();
    const user = newvalue.serviceuserid;
    const settlement = newvalue.settlementid;

    try {
      const userRef = db.collection("userlist").doc(user);
      const userDoc = await userRef.get();

      const settlementRef = db.collection("settlementlist").doc(settlement);
      const settlementDoc = await settlementRef.get();

      const master = settlementDoc.data().masteruserid;
      const masterRef = db.collection("userlist").doc(master);
      const masterDoc = await masterRef.get();

      const alarmTitle = "정산서 전송 알림";
      const alarmBody = masterDoc.data().name+ " 님이 보내신 " + settlementDoc.data().settlementname  + " 정산의 정산서가 도착하였어요!";
      const alarmId = uuid();

      const message = {
          notification: {
              title: alarmTitle,
              body: alarmBody,
            },
            data: {
              route: "/SettlementInformation",
              topic: "SendStmPaper",
              arg0: settlementDoc.data().settlementid,
              arg1: settlementDoc.data().groupid,
              arg2: userDoc.data().serviceuserid,
            },
            token: userDoc.data().fcmtoken,
        };
      const alarm = {
            alarmid: alarmId,
            title: alarmTitle,
            body: alarmBody,
            category: 1,
            route: "/SettlementInformation",
            args: [
                settlementDoc.data().settlementid,
                settlementDoc.data().groupid,
                userDoc.data().serviceuserid
            ],
            isread: false,
            time: admin.firestore.Timestamp.fromDate(new Date())
      };
      const alarmDoc = await db.collection("alarmlist").doc(userDoc.data().serviceuserid)
      .collection("myalarmlist").get();
      const alarmCnt = alarmDoc.size;
      console.log("알림 수: ", alarmCnt);
      if(alarmCnt > 60) {
         const collectionRef = db.collection("alarmlist").doc(userDoc.data().serviceuserid)
            .collection("myalarmlist").orderBy("time").limit(1);
         const collectionsnapshot = await collectionRef.get();
         const oldestDoc = collectionsnapshot.docs[0];
         const oldestid = oldestDoc.data().alarmid;
         await  db.collection("alarmlist").doc(userDoc.data().serviceuserid)
                .collection("myalarmlist").doc(oldestid).delete();
      }
      db.collection("alarmlist").doc(userDoc.data().serviceuserid)
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

});

exports.sendNtf_CheckSent  = functions.region("asia-northeast3").firestore
                            .document("settlementlist/{docId}").onUpdate(async (change, context) => {
      const prev = change.before.data();
      const prevMap = new Map(prev.checksent);

      const now = change.after.data();
      const nowMap = new Map(now.checksent);

      const settlementname = now.settlementname;

      const master = now.masteruserid;
      const masterRef = db.collection("userlist").doc(master);
      const masterDoc = await masterRef.get();

      for(const [key,value] of nowMap) {
        const prevValue = prevMap[key];
        if(prevValue != value) {
          const userRef = db.collection("userlist").doc(key);
          const userDoc = await userRef.get();

          try {

            if(prevValue == 0 && value == 1) {
              const alarmTitle = "송금 확인 요청 알림";
              const alarmBody = settlementname + " 정산: " + userDoc.data().name+ " 님이 보내신 송금을 확인해주세요!";
              const alarmId = uuid();

              const message = {
                    notification: {
                        title: alarmTitle,
                        body: alarmBody,
                      },
                      data: {
                        route: "/SettlementInformation",
                        topic: "RequestCheckSent",
                      },
                      token: userDoc.data().fcmtoken,
                  };

              const alarm = {
                      alarmid: alarmId,
                      title: alarmTitle,
                      body: alarmBody,
                      category: 0,
                      route: "/SettlementInformation",
                      isread: false,
                      time: admin.firestore.Timestamp.fromDate(new Date())
                };
              const alarmDoc = await db.collection("alarmlist").doc(userDoc.data().serviceuserid)
              .collection("myalarmlist").get();
              const alarmCnt = alarmDoc.size;
              console.log("알림 수: ", alarmCnt);
              if(alarmCnt > 60) {
                 const collectionRef = db.collection("alarmlist").doc(userDoc.data().serviceuserid)
                    .collection("myalarmlist").orderBy("time").limit(1);
                 const collectionsnapshot = await collectionRef.get();
                 const oldestDoc = collectionsnapshot.docs[0];
                 const oldestid = oldestDoc.data().alarmid;
                 await  db.collection("alarmlist").doc(userDoc.data().serviceuserid)
                        .collection("myalarmlist").doc(oldestid).delete();
              }
              db.collection("alarmlist").doc(userDoc.data().serviceuserid)
                .collection("myalarmlist").doc(alarmId).set(alarm);

              admin.messaging().send(message).then((response) => {
                  console.log("Successfully sent message:", response);
                })
                .catch((error) => {
                  console.log("Error sending message:", error);
                });
            }
            else if(prevValue == 1 && value == 2) {
              const alarmTitle = "송금 재요청 알림";
              const alarmBody = settlementname + " 정산: " + "회원님의 송금이 반려되었어요. 확인 후 다시 송금해주세요!";
              const alarmId = uuid();

              const message = {
                    notification: {
                        title: alarmTitle,
                        body: alarmBody,
                      },
                      data: {
                        route: "/SettlementInformation",
                        topic: "RequestCheckSent",
                      },
                      token: userDoc.data().fcmtoken,
                  };

              const alarm = {
                      alarmid: alarmId,
                      title: alarmTitle,
                      body: alarmBody,
                      category: 1,
                      route: "/SettlementInformation",
                    isread: false,
                    time: admin.firestore.Timestamp.fromDate(new Date())
                };
              const alarmDoc = await db.collection("alarmlist").doc(userDoc.data().serviceuserid)
              .collection("myalarmlist").get();
              const alarmCnt = alarmDoc.size;
              console.log("알림 수: ", alarmCnt);
              if(alarmCnt > 60) {
                 const collectionRef = db.collection("alarmlist").doc(userDoc.data().serviceuserid)
                    .collection("myalarmlist").orderBy("time").limit(1);
                 const collectionsnapshot = await collectionRef.get();
                 const oldestDoc = collectionsnapshot.docs[0];
                 const oldestid = oldestDoc.data().alarmid;
                 await  db.collection("alarmlist").doc(userDoc.data().serviceuserid)
                        .collection("myalarmlist").doc(oldestid).delete();
              }
              db.collection("alarmlist").doc(userDoc.data().serviceuserid)
                .collection("myalarmlist").doc(alarmId).set(alarm);

              admin.messaging().send(message).then((response) => {
                  console.log("Successfully sent message:", response);
                })
                .catch((error) => {
                  console.log("Error sending message:", error);
                });
            }
            else if(prevValue == 1 && value == 3) {
              const alarmTitle = "송금 확인 알림";
              const alarmBody = settlementname + " 정산: " + masterDoc.data().name+ "님이 송금을 컨펌하였어요!";
              const alarmId = uuid();

              const message = {
                    notification: {
                        title: alarmTitle,
                        body: alarmBody,
                      },
                      data: {
                        route: "/SettlementInformation",
                        topic: "RequestCheckSent",
                      },
                      token: userDoc.data().fcmtoken,
                  };

              const alarm = {
                      alarmid: alarmId,
                      title: alarmTitle,
                      body: alarmBody,
                      category: 1,
                      route: "/SettlementInformation",
                      isread: false,
                      time: admin.firestore.Timestamp.fromDate(new Date())
                };
              const alarmDoc = await db.collection("alarmlist").doc(userDoc.data().serviceuserid)
              .collection("myalarmlist").get();
              const alarmCnt = alarmDoc.size;
              console.log("알림 수: ", alarmCnt);
              if(alarmCnt > 60) {
                 const collectionRef = db.collection("alarmlist").doc(userDoc.data().serviceuserid)
                    .collection("myalarmlist").orderBy("time").limit(1);
                 const collectionsnapshot = await collectionRef.get();
                 const oldestDoc = collectionsnapshot.docs[0];
                 const oldestid = oldestDoc.data().alarmid;
                 await  db.collection("alarmlist").doc(userDoc.data().serviceuserid)
                        .collection("myalarmlist").doc(oldestid).delete();
              }
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
        }
      }
});

exports.sendNtf_finishSettlement  = functions.region("asia-northeast3").firestore
                            .document("settlementlist/{docId}").onUpdate(async (change, context) => {

  const prev = change.before.data();
  const now = change.after.data();
  const settlmentGroup = now.groupid;

  if (prev.isfinished != now.isfinished) {
      try {

        const groupRef = db.collection("grouplist").doc(settlmentGroup);
        const groupDoc = await groupRef.get();
        const serviceusers = groupDoc.data().serviceusers;

        for(const user of serviceusers) {
            if(user == now.masteruserid) continue;
            const userRef = db.collection("userlist").doc(user);
            const userDoc = await userRef.get();

            const alarmTitle = "정산 종료 알림";
            const alarmBody = now.settlementname + " 정산이 종료되었어요.";
            const alarmId = uuid();

            const message = {
                  notification: {
                      title: alarmTitle,
                      body: alarmBody,
                    },
                    data: {
                      route: "/SettlementInformation",
                      topic: "finishSettlement",
                    },
                    token: userDoc.data().fcmtoken,
                };

            const alarm = {
                    alarmid: alarmId,
                    title: alarmTitle,
                    body: alarmBody,
                    category: 1,
                    route: "/SettlementInformation",
                    isread: false,
                    time: admin.firestore.Timestamp.fromDate(new Date())
              };
            const alarmDoc = await db.collection("alarmlist").doc(userDoc.data().serviceuserid)
            .collection("myalarmlist").get();
            const alarmCnt = alarmDoc.size;
            console.log("알림 수: ", alarmCnt);
            if(alarmCnt > 60) {
               const collectionRef = db.collection("alarmlist").doc(userDoc.data().serviceuserid)
                  .collection("myalarmlist").orderBy("time").limit(1);
               const collectionsnapshot = await collectionRef.get();
               const oldestDoc = collectionsnapshot.docs[0];
               const oldestid = oldestDoc.data().alarmid;
               await  db.collection("alarmlist").doc(userDoc.data().serviceuserid)
                      .collection("myalarmlist").doc(oldestid).delete();
            }
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

  }
});
