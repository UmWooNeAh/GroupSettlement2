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

  fetchData(String userId) async{
    //User Fetch
    fetchUser(userId);

    List<Group> groups = await Group().getGroupList();
    groups.forEach((group) {
      group.Users!.forEach((user) {
        if(user == userId){
          //Group Fetch
          myGroup!.add(group);
          fetchSettlement(group.Settlements!);
        }
      });
    });
  }

  fetchUser(String userId)async{
    userData = await User().getUserByUserId(userId);
  }

  fetchSettlement(List<String> set) async{
    set.forEach((id) async{
      Settlement temp = Settlement();
      temp = await Settlement().getSettlementBySettlementId(id);
      //Settlement Fetch
      mySettlements!.add(temp);
      fetchPaper(temp.SettlementPapers!);
    });
  }

  fetchPaper(List<String> paper)async{
    paper.forEach((id) async{
      //SettlementPaper Fetch
      mySettlementPapers!.add(await SettlementPaper().getSettlementPaperByPaperId(id));
    });
  }


}




