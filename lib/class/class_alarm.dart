import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:groupsettlement2/modeluuid.dart';

class Alarm {

  String? alarmId;
  String? title;
  String? body;
  int? category;

  Alarm ({
    this.alarmId,
    this.title,
    this.body,
    this.category
  });

  Alarm.fromJson(dynamic json) {
    alarmId = json['alarmid'];
    title = json['title'];
    body = json['body'];
    category = json['category'];
  }

  Map<String, dynamic> toJson() => {
    'alarmid' : alarmId,
    'title' : title,
    'body' : body,
    'category' : category
  };

  Future<List<Alarm>> getAlarmListByUserId(String userid) async{
    List<Alarm> alarmlist = [];
    await FirebaseFirestore.instance.collection("alarmlist").doc(userid)
            .collection('myalarmlist').get().then((querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          Alarm alarm = Alarm.fromSnapShot(docSnapshot);
          alarmlist.add(alarm);
        }
      },
      onError: (e) => print("Error completing: $e"),
    );

    return alarmlist;
  }

  Alarm.fromSnapShot(
      DocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data());

}