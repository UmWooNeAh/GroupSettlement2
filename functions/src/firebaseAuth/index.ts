import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

export const createCustomToken = functions.region("asia-northeast3").https.onRequest(async (request, response) => {
    const user:any = request.body;

    const uid:string = "kakao:"+ user.uid;
    const updateParams:any = {
        email: user.email,
        photoURL: user.photoURL,
        displayName: user.displayName,
    }
    const userRef = db.collection("userlist");
    
    try {
        await admin.auth().updateUser(uid, updateParams);
    } catch(e) {
        updateParams["uid"] = uid;
        await admin.auth().createUser(updateParams);

    }
    const token = await admin.auth().createCustomToken(uid);
    response.send(token);
});