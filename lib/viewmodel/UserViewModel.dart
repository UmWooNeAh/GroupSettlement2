import '../class/class_group.dart';
import '../class/class_settlement.dart';
import '../class/class_settlementpaper.dart';
import '../class/class_user.dart';
class UserViewModel {

  ServiceUser userData = ServiceUser();
  List<Group> myGroup = <Group> [];
  List<Settlement> mySettlements = <Settlement> [];
  List<SettlementPaper> mySettlementPapers = <SettlementPaper> [];

  UserViewModel(String userId)
  {
    _settingUserViewModel(userId);
  }

  void _settingUserViewModel(String userId) {
    fetchUser(userId);
    fetchGroup(userId);
    for(var group in myGroup)
    {
      fetchSettlement(group.settlements);
    }
    for(var stm in mySettlements)
    {
      fetchStmPaper(stm.settlementPapers);
    }
  }

  void fetchUser(String userId) async {
    userData = await ServiceUser().getUserByUserId(userId);
  }

  void fetchGroup(String userId) async {

    List<Group> groups = await Group().getGroupList();
    groups.forEach((group) {
      group.serviceUsers.forEach((user) {
        if(user == userId){
          //Group Fetch
          myGroup.add(group);
        }
      });
    });
  }

  void fetchSettlement(List<String> stms) async {
    stms.forEach((id) async{
      Settlement temp = await Settlement().getSettlementBySettlementId(id);
      //Settlement Fetch
      mySettlements.add(temp);
    });
  }

  void fetchStmPaper(Map<String, String> stmpapers) async{
    stmpapers.forEach((key, value) async {
      //SettlementPaper Fetch
      SettlementPaper temp = await SettlementPaper().getSettlementPaperByPaperId(value);
      mySettlementPapers.add(temp);
    });
  }

}




