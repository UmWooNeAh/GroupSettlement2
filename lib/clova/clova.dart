import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../class/class_receipt.dart';
import '../class/class_receiptitem.dart';
class Clova {
  final apiURL = 'https://zp8rrjf47i.apigw.ntruss.com/custom/v1/24397/7b50d31ceaa021de059374371153a3ef5f1353a184df9ebd874269a23a174339/document/receipt';
  String? secretKey;
  File? imageFile;
  final ImagePicker picker = ImagePicker();
  var res;
  var uuid = Uuid();
  List<ReceiptItem> a = [];

  Map<String, dynamic> requestJSON = {
    'images': [
      {
        'format': '',
        'name': '',
      },
    ],
    'requestId': Uuid().v4(),
    'version': 'V2',
    'timestamp': DateTime
        .now()
        .millisecondsSinceEpoch,
  };


  getSecretKey() async {
    //secretKey = await File("key.txt").readAsString();
    secretKey = 'V1J5c1VaWVd5WkpoWmZMU0RNTlNsVnFyb0xkWUdaRXQ=';
  }

  getImageByFile(File receipt) {
    imageFile = receipt;
    a = [];
  }

  Clova();

  Future<dynamic> analyze() async {
    var path = imageFile!.path.split('.');
    String name;
    String format;

    if (path.length <= 1) {
      print("Path error : invalid path");
      return null;
    }
    name = path.first;
    format = path.last;
    requestJSON['images'][0]['name'] = name;
    requestJSON['images'][0]['format'] = format;

    await getSecretKey();

    final payload = {'message': jsonEncode(requestJSON)};
    final headers = {'X-OCR-SECRET': secretKey!};

    final request = http.MultipartRequest('POST', Uri.parse(apiURL))
      ..headers.addAll(headers)
      ..fields.addAll(payload)
      ..files.add(await http.MultipartFile.fromPath('file', imageFile!.path));

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        res = jsonDecode(responseBody);

        // final outputFile = File('./output.json');
        // await outputFile.writeAsString(jsonEncode(res), encoding: utf8);
        //print(res['images'][0]['receipt']['result']['subResults'][0]);
        log(res.toString());
        this.res = res;
        return res;
      } else {
        print('POST failed: ${response.statusCode}');
      }
    } catch (error) {
      print('Error occured: $error');
    }
  }

  Future<void> pickPicture() async {
    final XFile? images = await picker.pickImage(source: ImageSource.gallery);
    if (images != null) {
      this.imageFile = File(images.path);
    }
  }

  Future<void> takePicture() async {
    final XFile? images = await picker.pickImage(source: ImageSource.camera);
    if (images != null) {
      this.imageFile = File(images.path);
    }
  }

  Receipt makeReceipt() {
    Receipt receipt = Receipt(receiptId: 'a',
        receiptItems: [],
        storeName: '',
        time: DateTime.now(),
        totalPrice:0);
    //가게 이름
    try {
      receipt.storeName =
      res['images'][0]['receipt']['result']['storeInfo']['name']['text'];
    }catch(e){ receipt.storeName = "NotFound";}
    //총 가격
    try {
      receipt.totalPrice =
          int.parse(
              res['images'][0]['receipt']['result']['totalPrice']['price']['formatted']['value']);
    }catch(e){ receipt.totalPrice = -1;}
    int itemLength = res['images'][0]['receipt']['result']['subResults'][0]['items']
        .length;
    //영수증 항목
    for (int i = 0; i < itemLength; i++) {
      var temp = res['images'][0]['receipt']['result']['subResults'][0]['items'][i];
      var name = temp['name']['text'];
      var count, price;

      //print("price: ${int.parse(temp['price']['price']['formatted']['value'])}");

      //항목 가격
      try {
        price = int.parse(temp['price']['price']['formatted']['value']);
      }catch(e){
        price = -1;
        print("Error occured processing price text : $e");
      }
      //항목 개수
      try{
        count = int.parse(temp['count']['text']);
      }catch(e){
        count = -1;
        print("Error occured processing count text : $e");
      }
      print(name + count.toString() + ' ' + price.toString());
      //id
      var id = uuid.v4();
      ReceiptItem item = ReceiptItem(receiptItemId: id,
          serviceUsers: [],
          menuName: name,
          menuCount: count,
          menuPrice: price);
      a.add(item);
      receipt.receiptItems!.add(id);
    }
    return receipt;
  }
}



void main() async{
  Clova test = Clova();
  test.getImageByFile(File('d.jpg'));
  var result = await test.analyze();
  // print(result);
  int itemLength;
  itemLength = result['images'][0]['receipt']['result']['subResults'][0]['items'].length;

  // Receipt receipt = Receipt(receiptId: 'a',receiptItems: [],storeName: ,time:,totalPrice:);
  // receipt.storeName = result['images'][0]['receipt']['result']['storeInfo']['name']['text'];
  // receipt.totalPrice = result['images'][0]['receipt']['result']['totalPrice']['price']['text'];
  //
  // for(int i=0;i<itemLength;i++){
  //   var temp = result['images'][0]['receipt']['result']['subResults'][0]['items'][i];
  //   var name = temp['name']['text'];
  //   var count = int.parse(temp['count']['text']);
  //   var price = int.parse(temp['price']['price']['text'].replaceAll(',',''));
  //
  // print(name+count.toString()+' '+price.toString());
  //
  // ReceiptItem item = ReceiptItem(receiptItemId: 'a',serviceUsers:[],menuName:name,menuCount:count,menuPrice: price);

  // }
}

