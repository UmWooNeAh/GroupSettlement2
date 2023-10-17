import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groupsettlement2/class/class_group.dart';
import 'package:groupsettlement2/class/class_user.dart';
import 'package:groupsettlement2/common_fireservice.dart';
import 'package:groupsettlement2/modeluuid.dart';
import '../class/class_receipt.dart';
import '../class/class_receiptitem.dart';
import '../class/class_settlement.dart';
import '../class/class_settlementitem.dart';
import '../class/class_settlementpaper.dart';

final stmProvider =
    ChangeNotifierProvider<SettlementViewModel>((ref) => SettlementViewModel());

class SettlementViewModel extends ChangeNotifier {
  // Information
  Group group = Group();
  Settlement settlement = Settlement();
  List<ServiceUser> settlementUsers = <ServiceUser>[];
  Map<String, Receipt> receipts = <String, Receipt>{};
  Map<String, List<ReceiptItem>> receiptItems = <String, List<ReceiptItem>>{};

  // Management
  List<String> finalSettlement = <String>[];
  Map<String, List<String>> subGroups = <String, List<String>>{};
  Map<String, SettlementPaper> settlementPapers = <String, SettlementPaper>{};
  Map<String, List<SettlementItem>> settlementItems =
      <String, List<SettlementItem>>{};

  SettlementViewModel();

  void settingSettlementViewModel(String settlementId) async {
    group = Group();
    settlement = Settlement();
    settlementUsers = <ServiceUser>[];
    receipts = <String, Receipt>{};
    receiptItems = <String, List<ReceiptItem>>{};

    // Management
    finalSettlement = <String>[];
    subGroups = <String, List<String>>{};
    settlementPapers = <String, SettlementPaper>{};
    settlementItems = <String, List<SettlementItem>>{};

    settlement = await Settlement().getSettlementBySettlementId(settlementId);
    group = await Group().getGroupByGroupId(settlement.groupId!);
    //log("정산 이름: ${settlement.settlementName}");
    //정산자 제외하고 그룹의 유저 목록 불러오기

    ServiceUser muser =
        await ServiceUser().getUserByUserId(settlement.masterUserId!);
    settlementUsers.add(muser);

    for (var userid in group.serviceUsers) {
      if (userid == settlement.masterUserId) {
        continue;
      }
      ServiceUser user = await ServiceUser().getUserByUserId(userid);
      settlementUsers.add(user);
    }

    settlement.receipts.forEach((receipt) async {
      // Settlement -> Receipt 하나씩 불러오기
      Receipt newReceipt = await Receipt().getReceiptByReceiptId(receipt);
      receipts[receipt] = newReceipt;

      receipts[receipt]!.receiptItems.forEach((receiptitemid) async {
        // Receipt -> ReceiptItem 하나씩 불러오기
        ReceiptItem newReceiptItem =
            await ReceiptItem().getReceiptItemByReceiptItemId(receiptitemid);
        if (receiptItems[receipt] == null) {
          receiptItems[receipt] = [newReceiptItem];
        } else {
          receiptItems[receipt]!.add(newReceiptItem);
        }
        notifyListeners();
      });
      notifyListeners();
    });
    notifyListeners();
  }

  void addSettlementItem(
      String receiptId, int index, String receiptItemId, String userId) {
    // receiptItem이 선택이 되었는지에 따라 userId를 추가해주기 + 처음 선택됐을 때 finalSettlement에 추가
    if (receiptItems[receiptId]![index].serviceUsers[userId] != null) {
      return;
    }

    late String userName;
    for (var user in settlementUsers) {
      if (user.serviceUserId == userId) {
        userName = user.name!;
        break;
      }
    }

    if (settlementPapers[userId] == null) {
      finalSettlement.add(userId);
    }
    receiptItems[receiptId]![index].serviceUsers[userId] = userName;

    _addItemToSettlementPaper(receiptId, index, userId);
    _updateSettlementItemPrice(receiptId, index);
    notifyListeners();
  }

  void addSettlementItemBySubGroup(
      String receiptId, int index, String subGroupId, String subGroupName) {
    receiptItems[receiptId]![index].serviceUsers[subGroupId] = subGroupName;

    for (var userid in subGroups[subGroupId]!) {
      _addItemToSettlementPaper(receiptId, index, userid);
    }
    _updateSettlementItemPrice(receiptId, index);
    notifyListeners();
  }

  void deleteSettlementItem(String receiptId, int index, String userId) {
    _deleteItemToSettlementPaper(receiptId, index, userId);
    // ReceiptItem에 매칭되어있는 user 삭제
    receiptItems[receiptId]![index].serviceUsers.remove(userId);

    if (settlementPapers[userId] == null) {
      finalSettlement.remove(userId);
    }

    _updateSettlementItemPrice(receiptId, index);
    if (settlementPapers[userId] != null) {
      settlementPapers[userId]!.totalPrice = 0;
      for (int i = 0;
          i < settlementPapers[userId]!.settlementItems.length;
          i++) {
        settlementPapers[userId]!.totalPrice =
            settlementPapers[userId]!.totalPrice! +
                settlementItems[userId]![i].price!;
      }
    }

    notifyListeners();
  }

  void deleteSettlementItemBySubGroup(
      String receiptId, int index, String subGroupId) {
    for (var userid in subGroups[subGroupId]!) {
      _deleteItemToSettlementPaper(receiptId, index, userid);
    }

    for (var userid in subGroups[subGroupId]!) {
      receiptItems[receiptId]![index].serviceUsers.remove(userid);
    }

    if (receiptItems[receiptId]![index].serviceUsers.isEmpty) {
      finalSettlement.remove(receiptItems[receiptId]![index].receiptItemId);
    } else {
      _updateSettlementItemPrice(receiptId, index);
    }
    notifyListeners();
  }

  void _addItemToSettlementPaper(String receiptId, int index, String userId) {
    // userId에 따른 SettlementPaper가 없었을 때 생성후 settlement에 등록
    if (!settlementPapers.containsKey(userId)) {
      SettlementPaper newSettlementPaper = SettlementPaper();
      // newSettlementPaper.settlementPaperId =
      newSettlementPaper.userName =
          receiptItems[receiptId]![index].serviceUsers[userId];
      newSettlementPaper.serviceUserId = userId;
      newSettlementPaper.accountInfo = settlement.accountInfo;
      newSettlementPaper.settlementId = settlement.settlementId;
      settlementPapers[userId] = newSettlementPaper;
      settlement.settlementPapers[userId] =
          newSettlementPaper.settlementPaperId!;
    }

    // item의 등록으로 인해 settlementItem 생성
    SettlementItem newSettlementItem = SettlementItem();
    newSettlementItem.receiptItemId =
        receiptItems[receiptId]![index].receiptItemId;
    newSettlementItem.menuName = receiptItems[receiptId]![index].menuName;
    newSettlementItem.menuCount =
        receiptItems[receiptId]![index].serviceUsers.length;
    newSettlementItem.price =
        receiptItems[receiptId]![index].menuPrice!.toDouble() /
            newSettlementItem.menuCount!.toDouble();
    newSettlementItem.receiptId = receiptId;

    settlementPapers[userId]!
        .settlementItems
        .add(newSettlementItem.settlementItemId!);
    if (settlementItems[userId] == null) {
      settlementItems[userId] = [newSettlementItem];
    } else {
      settlementItems[userId]!.add(newSettlementItem);
    }
    notifyListeners();
  }

  void _updateSettlementItemPrice(String receiptId, int index) {
    for (var userid in receiptItems[receiptId]![index].serviceUsers.keys) {
      for (int i = 0; i < settlementItems[userid]!.length; i++) {
        if (settlementItems[userid]![i].receiptItemId ==
            receiptItems[receiptId]![index].receiptItemId) {
          settlementItems[userid]![i].menuCount =
              receiptItems[receiptId]![index].serviceUsers.length;
          settlementItems[userid]![i].price =
              receiptItems[receiptId]![index].menuPrice!.toDouble() /
                  settlementItems[userid]![i].menuCount!.toDouble();
          settlementPapers[userid]!.totalPrice = 0;
          for (int j = 0; j < settlementItems[userid]!.length; j++) {
            settlementPapers[userid]!.totalPrice =
                settlementPapers[userid]!.totalPrice! +
                    settlementItems[userid]![j].price!;
          }
          break;
        }
      }
    }
    notifyListeners();
  }

  void _deleteItemToSettlementPaper(
      String receiptId, int index, String userId) {
    // SettlementItem 삭제 paper에서 item 삭제, item객체 삭제, item map에서 삭제
    for (var stmitem in settlementItems[userId]!) {
      if (stmitem.receiptItemId ==
          receiptItems[receiptId]![index].receiptItemId) {
        settlementItems[userId]!.remove(stmitem);
        settlementPapers[userId]!
            .settlementItems
            .remove(stmitem.settlementItemId);
        break;
      }
    }

    // SettlementPaper가 할당받은 settlementItem이 없다면 settlementpaper 삭제
    if (settlementPapers[userId]!.settlementItems.isEmpty) {
      for (var paper in settlement.settlementPapers.entries) {
        if (paper.value == settlementPapers[userId]!.settlementPaperId) {
          settlement.settlementPapers.remove(paper);
          break;
        }
      }

      settlementPapers.remove(userId);
    }
    notifyListeners();
  }

  void createSubGroup(String userId1, String userId2) {
    String newSubGroupId = ModelUuid().randomId;
    subGroups[newSubGroupId] = [userId1, userId2];
    notifyListeners();
  }

  void addUserToSubGroup(String subGroupId, String userId) {
    subGroups[subGroupId]!.add(userId);
    notifyListeners();
  }

  Future<int> completeSettlement() async {
    // settlement Create
    FireService().updateDoc(
        "settlementlist", settlement.settlementId!, settlement.toJson());

    // SettlementPaper Create
    for(var stmpaper in settlementPapers!.entries) {
      settlement.totalPrice += stmpaper.value.totalPrice!;
      stmpaper.value.createSettlementPaper();
    }
    // SettlementItem Create
    for(var stmitemlist in settlementItems!.entries) {
      for(var stmitem in stmitemlist.value) {
        stmitem.createSettlementItem();
      }
    }

    // User Update(송금자만 업데이트)
    for (var stmuser in settlementUsers) {
      ServiceUser user =
          await ServiceUser().getUserByUserId(stmuser.serviceUserId!);
      for (var stmpaper in settlementPapers.entries) {
        user.settlementPapers.add(stmpaper.value.settlementPaperId!);
      }
      FireService().updateDoc("userlist", user.serviceUserId!, user.toJson());
    }

    // Receipt Update
    for (var rcp in receipts.entries) {
      FireService().updateDoc("receiptlist", rcp.key, rcp.value.toJson());
    }

    // ReceiptItem Update
    for (var rcpitemlist in receiptItems.entries) {
      for (var rcpitem in rcpitemlist.value) {
        FireService().updateDoc(
            "receiptitemlist", rcpitem.receiptItemId!, rcpitem.toJson());
      }
    }
    notifyListeners();
    return 1;
  }

  void requestSettlement() async {
    for (var stmuser in settlementUsers) {
      ServiceUser user =
          await ServiceUser().getUserByUserId(stmuser.serviceUserId!);

      if (user.kakaoId == null) {
        //카카오톡 공유하기
      } else {
        //카카오 피커
      }
    }
    notifyListeners();
  }
}
