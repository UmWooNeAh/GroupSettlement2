import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groupsettlement2/view/shared_basic_widget.dart';
import 'package:groupsettlement2/viewmodel/shared_data.dart';

import '../class/class_receipt.dart';
import '../class/class_receiptitem.dart';
import '../clova/clova.dart';

final receiptProvider = ChangeNotifierProvider<ReceiptViewModel>((ref) {
  return ReceiptViewModel();
});

class ReceiptViewModel extends ChangeNotifier {
  Clova clova = Clova();
  Receipt newReceipt = Receipt();
  List<ReceiptItem> newReceiptItems = <ReceiptItem>[];
  List<TextEditingController> priceController = <TextEditingController>[];
  List<TextEditingController> menuController = <TextEditingController>[];
  List<TextEditingController> countController = <TextEditingController>[];

  ReceiptViewModel();

  void textEditorInitialize() {
    priceController = [];
    menuController = [];
    countController = [];
    for (ReceiptItem receiptItem in newReceiptItems) {
      menuController.add(TextEditingController(text: receiptItem.menuName));
      countController
          .add(TextEditingController(text: receiptItem.menuCount.toString()));
      priceController.add(TextEditingController(
          text: priceToString.format(receiptItem.menuPrice ?? 0)));
    }
  }

  void createReceiptFromNaverOCR(var json) {
    newReceipt = Receipt();
    newReceiptItems = [];
    notifyListeners();
    // => json 영수증 양식으로 변환하는 코드 필요
    try {
      newReceipt.storeName =
          json['images'][0]['receipt']['result']['storeInfo']['name']['text'];
    } catch (e) {
      newReceipt.storeName = "NotFound";
    }
    try {
      newReceipt.time = json['paymentInfo']['date']['text'] +
          " " +
          json['paymentInfo']['time']['text'];
    } catch (e) {
      newReceipt.time = null;
    }

    for (var item in json['images'][0]['receipt']['result']['subResults'][0]
        ['items']) {
      ReceiptItem rcpitem = ReceiptItem();
      rcpitem.menuName = item['name']['text'];
      try {
        rcpitem.menuCount = int.parse(item['count']['text']);
      } catch (e) {
        rcpitem.menuCount = -1;
      }

      try {
        rcpitem.menuPrice =
            int.parse(item['price']['price']['formatted']['value']);
      } catch (e) {
        try {
          rcpitem.menuPrice =
              int.parse(item['price']['price']['formatted']['value']);
        } catch (e) {
          rcpitem.menuPrice = -1000;
        }
      }
      newReceiptItems.add(rcpitem);
    }
    try {
      newReceipt.totalPrice = int.parse(json['images'][0]['receipt']['result']
          ['totalPrice']['price']['formatted']['value']);
    } catch (e) {
      newReceipt.totalPrice = -1000;
    }
    notifyListeners();
  }

  void addReceipt() {
    newReceipt.receiptItems = [];
    for (var newReceiptItem in newReceiptItems) {
      newReceipt.receiptItems.add(newReceiptItem.receiptItemId!);
    }
    sharedData.createNewReceipt(newReceipt, newReceiptItems);
  }

  List<int> completeEditReceipt() {
    newReceipt.totalPrice = priceController
        .map((price) => priceToString.parse(price.text))
        .reduce((value, element) => value + element)
        .toInt();
    for (var index in Iterable.generate(newReceiptItems.length)) {
      newReceiptItems[index].menuName = menuController[index].text;
      try {
        newReceiptItems[index].menuCount =
            int.parse(countController[index].text);
        if (newReceiptItems[index].menuCount! < 1) {
          return [-1, index];
        }
      } catch (e) {
        return [-1, index];
      }
      try {
        newReceiptItems[index].menuPrice =
            priceToString.parse(priceController[index].text).toInt();
      } catch (e) {
        return [-2, index];
      }
    }
    notifyListeners();
    return [1];
  }
}
