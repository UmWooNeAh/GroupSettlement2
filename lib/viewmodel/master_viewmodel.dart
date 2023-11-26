import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groupsettlement2/class/class_user.dart';

ChangeNotifierProvider<MasterViewModel> masterProvider =
    ChangeNotifierProvider<MasterViewModel>((ref) => MasterViewModel());

class MasterViewModel extends ChangeNotifier {
  ServiceUser? me;

  Future<void> fetchUserData(String userId) async {
    me = await ServiceUser().getUserByUserId(userId);
    return;
  }
}
