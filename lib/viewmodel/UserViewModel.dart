import '../class/class_group.dart';
import '../class/class_settlement.dart';
import '../class/class_settlementpaper.dart';
import '../class/class_user.dart';

class UserViewModel {

  ServiceUser? userData;
  List<Group>? myGroup;
  List<Settlement>? mySettlements;
  List<SettlementPaper>? mySettlementPapers;

  UserViewModel(String userId) {
    fetchData(userId);
  }

  fetchData(String userId) async {
    //User Fetch
    fetchUser(userId);

    List<Group> groups = await Group().getGroupList();
    groups.forEach((group) {
      group.serviceUsers!.forEach((user) {
        if(user == userId){
          //Group Fetch
          myGroup!.add(group);
          fetchSettlement(group.settlements!);
        }
      });
    });
  }

  fetchUser(String userId) async {
    userData = await ServiceUser().getUserByUserId(userId);
  }

  fetchSettlement(List<String> stm) async {
    stm.forEach((id) async{
      Settlement temp = await Settlement().getSettlementBySettlementId(id);
      //Settlement Fetch
      mySettlements!.add(temp);
      fetchPaper(temp.settlementPapers!);
    });
  }

  fetchPaper(Map<String, String> stmpapers) async{
    stmpapers.forEach((key, value) async {
      //SettlementPaper Fetch
      SettlementPaper temp = await SettlementPaper().getSettlementPaperByPaperId(value);
      mySettlementPapers!.add(temp);
    });
  }


}




