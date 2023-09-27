import 'package:flutter/cupertino.dart';
import 'package:groupsettlement2/common_fireservice.dart';
import '../class/class_alarm.dart';


class AlarmViewModel {

  List<Alarm> receiveStmAlarm = <Alarm> [];
  List<Alarm> sendStmAlarm = <Alarm> [];
  List<Alarm> etcStmAlarm = <Alarm> [];
  String? user;

  AlarmViewModel(String userid) {
    _settingAlarmViewModel(userid);
  }

  void _settingAlarmViewModel(String userid) async{
    user = userid;
    List<Alarm> allalarmlist = await Alarm().getAlarmListByUserId(userid);
    classifyAlarm(allalarmlist);
  }

  void classifyAlarm(List<Alarm> allalarmlist) {

    for(var alarm in allalarmlist) {
      if(alarm.category == 0) {
        receiveStmAlarm.add(alarm);
      }
      else if(alarm.category == 1) {
        sendStmAlarm.add(alarm);
      }
      else if(alarm.category == 2) {
        etcStmAlarm.add(alarm);
      }
    }
  }

  void linkAlarm() {

  }

  void deleteAlarm(int category, int i, String alarmid) async {

    if(category == 0) {
        receiveStmAlarm.removeAt(i);
    }
    else if(category == 1) {
        sendStmAlarm.removeAt(i);
    }
    else if(category == 2) {
        etcStmAlarm.removeAt(i);
    }
    FireService().deleteDoc("alarmlist/" + user! + "/myalarmlist", alarmid);
  }


}