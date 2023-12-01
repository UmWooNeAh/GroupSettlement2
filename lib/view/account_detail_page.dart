import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groupsettlement2/view/shared_basic_widget.dart';
import 'package:groupsettlement2/viewmodel/UserViewModel.dart';

import '../class/class_account.dart';
import '../design_element.dart';

class AccountDetailPage extends ConsumerStatefulWidget {
  const AccountDetailPage({Key? key}) : super(key: key);

  @override
  ConsumerState<AccountDetailPage> createState() => _AccountDetailPageState();
}

class _AccountDetailPageState extends ConsumerState<AccountDetailPage> {

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final provider = ref.watch(userProvider);
    print(provider.userData.accountInfo.length);
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left:20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width:1,height:size.height*0.12),
                Text("마이페이지",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    )
                ),
                SizedBox(height:size.height*0.02),
                Text("나의 계좌 목록",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
          ),
          SizedBox(height:size.height*0.05),
          Column(
            children: List.generate(provider.accounts.length, (index){
              Account account = provider.accounts[index];
              return oneAccount(accountNum: account.accountNum.toString(),nickName: account.accountAlias!,bankName: account.bank!,isFavorite: index == 0,);
            })
          ),

    ],
    ),

      bottomNavigationBar: CustomBottomNavigationBar(index: 4,isIn: false),
    );
  }
}

class oneAccount extends StatefulWidget {
  final String nickName;
  final String bankName;
  final String accountNum;
  final bool isFavorite;
  const oneAccount({Key? key,required this.nickName, required this.accountNum, required this.bankName,required this.isFavorite}) : super(key: key);

  @override
  State<oneAccount> createState() => _oneAccountState();
}

class _oneAccountState extends State<oneAccount> {
  bool viewDetail = false;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    double fontsize = widget.isFavorite ? 15 : 14;
    double detailSize = widget.isFavorite ? size.height*0.22 : size.height*0.2;
    double simpleSize = widget.isFavorite ? size.height*0.11 : size.height*0.075;
    return GestureDetector(
      onTap:(){
        setState(() {
          viewDetail = !viewDetail;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 10),
        height: viewDetail ? detailSize : simpleSize,
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.isFavorite ? Text("대표 계좌",
                  style: TextStyle(
                    color: color1,
                    fontSize:20,
                    fontWeight: FontWeight.w600
                  ),
                ) : SizedBox.shrink(),
                Text(widget.nickName,
                  style: TextStyle(
                    fontSize: widget.isFavorite ? 20 : 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  children: [
                    Text(widget.bankName+" ",
                      style: TextStyle(
                        fontSize: fontsize,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    viewDetail ? SizedBox.shrink(): Text(widget.accountNum,
                      style: TextStyle(
                        fontSize: fontsize,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
                viewDetail ? Text(widget.accountNum,
                  style: TextStyle(
                    fontSize: fontsize,
                    fontWeight: FontWeight.w500,
                  ),
                ) : Divider(),
                SizedBox(height:10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        width:size.width*0.42,
                        height: 60,
                        child: OutlinedButton(
                            onPressed: (){
                            },
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text("계좌 수정",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ))
                    ),
                    Container(
                        width:size.width*0.42,
                        height: 60,
                        child: OutlinedButton(
                            onPressed: (){
                            },
                            style: OutlinedButton.styleFrom(
                              backgroundColor: color1,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text("계좌 삭제",
                              style: TextStyle(
                                color:Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ))
                    ),
                  ],
                ),
                Divider(),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
