import * as admin from "firebase-admin";
import serviceAccount from "./fir-df691-firebase-adminsdk-mrsg6-91cbd9caa4.json";
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount as admin.ServiceAccount),
  databaseURL: "https://fir-df691-default-rtdb.asia-southeast1.firebasedatabase.app",
});

import * as Group from "./group";
import * as Settlement from "./settlement";
import * as Friend from "./friend";
import * as FirebaseAuth from "./firebaseAuth";

export const sendNtf_CreateGroup = Group.sendNtf_CreateGroup;
export const sendNtf_CreateSettlement = Settlement.sendNtf_CreateSettlement;
export const sendNtf_SendSettlementPaper = Settlement.sendNtf_SendSettlementPaper;
export const sendNtf_CheckSent = Settlement.sendNtf_CheckSent;
export const sendNtf_finishSettlement = Settlement.sendNtf_finishSettlement;
export const sendNtf_requestedFriend = Friend.sendNtf_requestedFriend;
export const sendNtf_acceptFriend = Friend.sendNtf_acceptFriend;
export const createCustomToken = FirebaseAuth.createCustomToken;