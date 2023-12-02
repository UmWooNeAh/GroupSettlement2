import * as admin from "firebase-admin";
admin.initializeApp();
import * as Group from "./group";
import * as Settlement from "./settlement";
import * as Friend from "./friend";

export const sendNtf_CreateGroup = Group.sendNtf_CreateGroup;
export const sendNtf_CreateSettlement = Settlement.sendNtf_CreateSettlement;
export const sendNtf_SendSettlementPaper = Settlement.sendNtf_SendSettlementPaper;
export const sendNtf_CheckSent = Settlement.sendNtf_CheckSent;
export const sendNtf_finishSettlement = Settlement.sendNtf_finishSettlement;
export const sendNtf_requestedFriend = Friend.sendNtf_requestedFriend;
export const sendNtf_acceptFriend = Friend.sendNtf_acceptFriend;