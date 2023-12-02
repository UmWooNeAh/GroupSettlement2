import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import {v4} from "uuid";

const db = admin.firestore();
const uuid = (): string => {
    const tokens = v4().split("-");
    return tokens[2] + tokens[1] + tokens[0] + tokens[3] + tokens[4];
};

export const sendNtf_CreateSettlement = functions.region("asia-northeast3").firestore
    .document("settlementlist/{docId}").onCreate(async (snap) => {
        const newvalue: any = snap.data();
        const settlmentGroup: string = newvalue.groupid;

        const masterid: string = newvalue.masteruserid;
        const masterRef = db.collection("userlist").doc(masterid);
        const masterDoc = await masterRef.get();
        const masterData: any = masterDoc.data();

        const master: string = masterData.name;

        try {
            const groupRef = db.collection("grouplist").doc(settlmentGroup);
            const groupDoc = await groupRef.get();
            const groupData:any = groupDoc.data();
            const serviceusers: string[] = groupData.serviceusers;

            for (const userid of serviceusers) {
                if (userid == masterid) {

                    const alarmTitle: string = "정산 생성 알림";
                    const alarmBody: string = newvalue.settlementname + " 정산을 성공적으로 생성하였어요.";
                    const alarmId: string = uuid();

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
                        token: masterData.fcmtoken,
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

                    const alarmDoc = await db.collection("alarmlist").doc(masterData.serviceuserid)
                        .collection("myalarmlist").get();
                    const alarmCnt = alarmDoc.size;
                    console.log("알림 수: ", alarmCnt);
                    if (alarmCnt > 60) {
                        const collectionRef = db.collection("alarmlist").doc(masterData.serviceuserid)
                            .collection("myalarmlist").orderBy("time").limit(1);
                        const collectionsnapshot = await collectionRef.get();
                        const oldestDoc = collectionsnapshot.docs[0];
                        const oldestid = oldestDoc.data().alarmid;
                        await db.collection("alarmlist").doc(masterData.serviceuserid)
                            .collection("myalarmlist").doc(oldestid).delete();
                    }

                    db.collection("alarmlist").doc(masterData.serviceuserid)
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
                    const userData:any = userDoc.data();

                    const alarmTitle: string = "정산 생성 알림";
                    const alarmBody: string = master + " 님이 생성한 " + newvalue.settlementname + " 정산을 확인해보세요.";
                    const alarmId: string = uuid();

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
                        token: userData.fcmtoken,
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
                    const alarmDoc = await db.collection("alarmlist").doc(userData.serviceuserid)
                        .collection("myalarmlist").get();
                    const alarmCnt = alarmDoc.size;
                    console.log("알림 수: ", alarmCnt);
                    if (alarmCnt > 60) {
                        const collectionRef = db.collection("alarmlist").doc(userData.serviceuserid)
                            .collection("myalarmlist").orderBy("time").limit(1);
                        const collectionsnapshot = await collectionRef.get();
                        const oldestDoc = collectionsnapshot.docs[0];
                        const oldestid = oldestDoc.data().alarmid;
                        await db.collection("alarmlist").doc(userData.serviceuserid)
                            .collection("myalarmlist").doc(oldestid).delete();
                    }
                    db.collection("alarmlist").doc(userData.serviceuserid)
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

export const sendNtf_SendSettlementPaper = functions.region("asia-northeast3").firestore
    .document("settlementpaperlist/{docId}").onCreate(async (snap) => {
        const newvalue: any = snap.data();
        const user: string = newvalue.serviceuserid;
        const settlement: string = newvalue.settlementid;

        try {
            const userRef = db.collection("userlist").doc(user);
            const userDoc = await userRef.get();
            const userData:any = userDoc.data();

            const settlementRef = db.collection("settlementlist").doc(settlement);
            const settlementDoc = await settlementRef.get();
            const settlementData:any = settlementDoc.data();

            const master = settlementData.masteruserid;
            const masterRef = db.collection("userlist").doc(master);
            const masterDoc = await masterRef.get();
            const masterData: any = masterDoc.data();

            const alarmTitle: string = "정산서 전송 알림";
            const alarmBody: string = masterData.name + " 님이 보내신 " + settlementData.settlementname + " 정산의 정산서가 도착하였어요!";
            const alarmId: string = uuid();

            const message = {
                notification: {
                    title: alarmTitle,
                    body: alarmBody,
                },
                data: {
                    route: "/SettlementInformation",
                    topic: "SendStmPaper",
                    arg0: settlementData.settlementid,
                    arg1: settlementData.groupid,
                    arg2: userData.serviceuserid,
                },
                token: userData.fcmtoken,
            };
            const alarm = {
                alarmid: alarmId,
                title: alarmTitle,
                body: alarmBody,
                category: 1,
                route: "/SettlementInformation",
                args: [
                    settlementData.settlementid,
                    settlementData.groupid,
                    userData.serviceuserid
                ],
                isread: false,
                time: admin.firestore.Timestamp.fromDate(new Date())
            };
            const alarmDoc = await db.collection("alarmlist").doc(userData.serviceuserid)
                .collection("myalarmlist").get();
            const alarmCnt = alarmDoc.size;
            console.log("알림 수: ", alarmCnt);
            if (alarmCnt > 60) {
                const collectionRef = db.collection("alarmlist").doc(userData.serviceuserid)
                    .collection("myalarmlist").orderBy("time").limit(1);
                const collectionsnapshot = await collectionRef.get();
                const oldestDoc = collectionsnapshot.docs[0];
                const oldestid = oldestDoc.data().alarmid;
                await db.collection("alarmlist").doc(userData.serviceuserid)
                    .collection("myalarmlist").doc(oldestid).delete();
            }
            db.collection("alarmlist").doc(userData.serviceuserid)
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

export const sendNtf_CheckSent = functions.region("asia-northeast3").firestore
    .document("settlementlist/{docId}").onUpdate(async (change) => {
        const prev: any = change.before.data();
        const prevMap: Map<string, number> = new Map(prev.checksent);

        const now: any = change.after.data();
        const nowMap: Map<string, number> = new Map(now.checksent);

        const settlementname: string = now.settlementname;

        const master: string = now.masteruserid;
        const masterRef = db.collection("userlist").doc(master);
        const masterDoc = await masterRef.get();
        const masterData:any = masterDoc.data();

        for (const [key, value] of nowMap) {
            const prevValue = prevMap.get(key);
            if (prevValue != value) {
                const userRef = db.collection("userlist").doc(key);
                const userDoc = await userRef.get();
                const userData:any = userDoc.data();

                try {

                    if (prevValue == 0 && value == 1) {
                        const alarmTitle: string = "송금 확인 요청 알림";
                        const alarmBody: string = settlementname + " 정산: " + userData.name + " 님이 보내신 송금을 확인해주세요!";
                        const alarmId: string = uuid();

                        const message = {
                            notification: {
                                title: alarmTitle,
                                body: alarmBody,
                            },
                            data: {
                                route: "/SettlementInformation",
                                topic: "RequestCheckSent",
                            },
                            token: userData.fcmtoken,
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
                        const alarmDoc = await db.collection("alarmlist").doc(userData.serviceuserid)
                            .collection("myalarmlist").get();
                        const alarmCnt = alarmDoc.size;
                        console.log("알림 수: ", alarmCnt);
                        if (alarmCnt > 60) {
                            const collectionRef = db.collection("alarmlist").doc(userData.serviceuserid)
                                .collection("myalarmlist").orderBy("time").limit(1);
                            const collectionsnapshot = await collectionRef.get();
                            const oldestDoc = collectionsnapshot.docs[0];
                            const oldestid = oldestDoc.data().alarmid;
                            await db.collection("alarmlist").doc(userData.serviceuserid)
                                .collection("myalarmlist").doc(oldestid).delete();
                        }
                        db.collection("alarmlist").doc(userData.serviceuserid)
                            .collection("myalarmlist").doc(alarmId).set(alarm);

                        admin.messaging().send(message).then((response) => {
                            console.log("Successfully sent message:", response);
                        })
                            .catch((error) => {
                                console.log("Error sending message:", error);
                            });
                    }
                    else if (prevValue == 1 && value == 2) {
                        const alarmTitle: string = "송금 재요청 알림";
                        const alarmBody: string = settlementname + " 정산: " + "회원님의 송금이 반려되었어요. 확인 후 다시 송금해주세요!";
                        const alarmId: string = uuid();

                        const message = {
                            notification: {
                                title: alarmTitle,
                                body: alarmBody,
                            },
                            data: {
                                route: "/SettlementInformation",
                                topic: "RequestCheckSent",
                            },
                            token: userData.fcmtoken,
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
                        const alarmDoc = await db.collection("alarmlist").doc(userData.serviceuserid)
                            .collection("myalarmlist").get();
                        const alarmCnt = alarmDoc.size;
                        console.log("알림 수: ", alarmCnt);
                        if (alarmCnt > 60) {
                            const collectionRef = db.collection("alarmlist").doc(userData.serviceuserid)
                                .collection("myalarmlist").orderBy("time").limit(1);
                            const collectionsnapshot = await collectionRef.get();
                            const oldestDoc = collectionsnapshot.docs[0];
                            const oldestid = oldestDoc.data().alarmid;
                            await db.collection("alarmlist").doc(userData.serviceuserid)
                                .collection("myalarmlist").doc(oldestid).delete();
                        }
                        db.collection("alarmlist").doc(userData.serviceuserid)
                            .collection("myalarmlist").doc(alarmId).set(alarm);

                        admin.messaging().send(message).then((response) => {
                            console.log("Successfully sent message:", response);
                        })
                            .catch((error) => {
                                console.log("Error sending message:", error);
                            });
                    }
                    else if (prevValue == 1 && value == 3) {
                        const alarmTitle: string = "송금 확인 알림";
                        const alarmBody: string = settlementname + " 정산: " + masterData.name + "님이 송금을 컨펌하였어요!";
                        const alarmId: string = uuid();

                        const message = {
                            notification: {
                                title: alarmTitle,
                                body: alarmBody,
                            },
                            data: {
                                route: "/SettlementInformation",
                                topic: "RequestCheckSent",
                            },
                            token: userData.fcmtoken,
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
                        const alarmDoc = await db.collection("alarmlist").doc(userData.serviceuserid)
                            .collection("myalarmlist").get();
                        const alarmCnt = alarmDoc.size;
                        console.log("알림 수: ", alarmCnt);
                        if (alarmCnt > 60) {
                            const collectionRef = db.collection("alarmlist").doc(userData.serviceuserid)
                                .collection("myalarmlist").orderBy("time").limit(1);
                            const collectionsnapshot = await collectionRef.get();
                            const oldestDoc = collectionsnapshot.docs[0];
                            const oldestid = oldestDoc.data().alarmid;
                            await db.collection("alarmlist").doc(userData.serviceuserid)
                                .collection("myalarmlist").doc(oldestid).delete();
                        }
                        db.collection("alarmlist").doc(userData.serviceuserid)
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

export const sendNtf_finishSettlement = functions.region("asia-northeast3").firestore
    .document("settlementlist/{docId}").onUpdate(async (change) => {

        const prev: any = change.before.data();
        const now: any = change.after.data();
        const settlmentGroup: string = now.groupid;

        if (prev.isfinished != now.isfinished) {
            try {

                const groupRef = db.collection("grouplist").doc(settlmentGroup);
                const groupDoc = await groupRef.get();
                const groupData:any = groupDoc.data();
                const serviceusers: string[] = groupData.serviceusers;

                for (const user of serviceusers) {
                    if (user == now.masteruserid) continue;
                    const userRef = db.collection("userlist").doc(user);
                    const userDoc = await userRef.get();
                    const userData:any = userDoc.data();

                    const alarmTitle: string = "정산 종료 알림";
                    const alarmBody: string = now.settlementname + " 정산이 종료되었어요.";
                    const alarmId: string = uuid();

                    const message = {
                        notification: {
                            title: alarmTitle,
                            body: alarmBody,
                        },
                        data: {
                            route: "/SettlementInformation",
                            topic: "finishSettlement",
                        },
                        token: userData.fcmtoken,
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
                    const alarmDoc = await db.collection("alarmlist").doc(userData.serviceuserid)
                        .collection("myalarmlist").get();
                    const alarmCnt = alarmDoc.size;
                    console.log("알림 수: ", alarmCnt);
                    if (alarmCnt > 60) {
                        const collectionRef = db.collection("alarmlist").doc(userData.serviceuserid)
                            .collection("myalarmlist").orderBy("time").limit(1);
                        const collectionsnapshot = await collectionRef.get();
                        const oldestDoc = collectionsnapshot.docs[0];
                        const oldestid = oldestDoc.data().alarmid;
                        await db.collection("alarmlist").doc(userData.serviceuserid)
                            .collection("myalarmlist").doc(oldestid).delete();
                    }
                    db.collection("alarmlist").doc(userData.serviceuserid)
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

