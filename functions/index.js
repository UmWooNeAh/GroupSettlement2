const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();
const db = admin.firestore();

const { v4 } = require('uuid');
const uuid = () => {
    const tokens = v4().split('-')
    return tokens[2] + tokens[1] + tokens[0] + tokens[3] + tokens[4];
}

exports.sendNtf_CreateGroup  = functions.region("asia-northeast3").firestore
                                .document("grouplist/{docId}").onCreate(async (snap, context) => {
    const newvalue = snap.data();
    
    try {
          for(const user of newvalue.serviceuser) {
            const userRef = db.collection("userlist").doc(user);
            const userDoc = await userRef.get();

            const message = {
              notification: {
                  title: "그룹 생성 알림",
                  body: newvalue.groupname + " 그룹이 생성되었어요! 그룹에 소속된 사람들을 살펴보세요.",
                },
                token: userDoc.data().fcmtoken,
            };
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
        const userRef = db.collection("userlist").doc(userid);
        const userDoc = await userRef.get();

        const message = {
          notification: {
              title: "정산 생성 알림",
              body: master + " 님이 생성한 " + newvalue.settlementName + " 정산을 확인해보세요.",
            },
            token: userDoc.data().fcmtoken,
        };
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

exports.sendNtf_SendSettlementPaper  = functions.region("asia-northeast3").firestore
                            .document("settlementpaperlist/{docId}").onCreate(async (snap, context) => {
const newvalue = snap.data();
const user = newvalue.serviceuserid;
const settlement = newvalue.settlementid;

try {
      const userRef = db.collection("grouplist").doc(user);
      const userDoc = await userRef.get();

      const settlementRef = db.collection("settlementlist").doc(settlement);
      const settlementDoc = await settlementRef.get();

      const master = settlementDoc.data().masteruserid;
      const masterRef = db.collection("userlist").doc(master);
      const masterDoc = await masterRef.get();

      const message = {
          notification: {
              title: "정산서 전송 알림",
              body: masterDoc.data().name+ " 님이 보내신 " + settlementDoc.data().settlementname  + " 정산의 정산서를 확인해보세요!",
            },
            token: userDoc.data().fcmtoken,
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
          const message = {
            notification: {
                title: "송금 확인 요청 알림",
                body: settlementname + " 정산: " + userDoc.data().name+ " 님이 보내신 송금을 확인해주세요!",
              },
              token: masterDoc.data().fcmtoken,
          };
          admin.messaging().send(message).then((response) => {
              console.log("Successfully sent message:", response);
            })
            .catch((error) => {
              console.log("Error sending message:", error);
            });
        }
        else if(prevValue == 1 && value == 2) {
          const message = {
            notification: {
                title: "송금 재요청 알림",
                body: settlementname + " 정산: " + "회원님의 송금이 반려되었어요. 확인 후 다시 송금해주세요!",
              },
              token: userDoc.data().fcmtoken,
          };
          admin.messaging().send(message).then((response) => {
              console.log("Successfully sent message:", response);
            })
            .catch((error) => {
              console.log("Error sending message:", error);
            });
        }
        else if(prevValue == 1 && value == 3) {
          const message = {
            notification: {
                title: "송금 확인 알림",
                body: settlementname + " 정산: " + masterDoc.data().name+ "님이 송금을 컨펌하였어요!",
              },
              token: userDoc.data().fcmtoken,
          };
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
            const userRef = db.collection("userlist").doc(user);
            const userDoc = await userRef.get();
            
            const message = {
                notification: {
                    title: "정산 종료 알림",
                    body: now.settlementname + " 정산이 종료되었어요.",
                  },
                  token: userDoc.data().fcmtoken,
            };
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