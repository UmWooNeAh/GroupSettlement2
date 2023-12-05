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
  int viewDetailIndex = -1;
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
              return GestureDetector(
                onTap: (){
                  setState(() {
                    viewDetailIndex = viewDetailIndex == index ? -1 : index;
                  });
                },
                  child: oneAccount(
                    account: provider.accounts[index],
                    isFavorite: index == 0,
                    viewDetail: viewDetailIndex == index,));
            })
          ),

    ],
    ),

      bottomNavigationBar: CustomBottomNavigationBar(index: 4,isIn: false),
    );
  }
}

class oneAccount extends ConsumerStatefulWidget {
  final Account account;
  final bool isFavorite;
  final bool viewDetail;
  const oneAccount({Key? key,required this.account,required this.isFavorite,required this.viewDetail}) : super(key: key);

  @override
  ConsumerState<oneAccount> createState() => _oneAccountState();
}

class _oneAccountState extends ConsumerState<oneAccount> {

  @override
  Widget build(BuildContext context) {
    bool viewDetail = widget.viewDetail;
    final Size size = MediaQuery.of(context).size;
    double fontsize = widget.isFavorite ? 15 : 14;
    double detailSize = widget.isFavorite ? size.height*0.23 : size.height*0.18;
    double simpleSize = widget.isFavorite ? size.height*0.11 : size.height*0.08;
    final provider = ref.watch(userProvider);
    return AnimatedContainer(
      curve: Curves.fastEaseInToSlowEaseOut,
      duration: Duration(milliseconds: 500),
      height: viewDetail ? detailSize : simpleSize,
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            Padding(
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
                  Text(widget.account.accountAlias!,
                    style: TextStyle(
                      fontSize: widget.isFavorite ? 20 : 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    children: [
                      Text(widget.account.bank!+" ",
                        style: TextStyle(
                          fontSize: fontsize,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      viewDetail ? SizedBox.shrink(): Text(widget.account.accountNum!.toString(),
                        style: TextStyle(
                          fontSize: fontsize,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                  viewDetail ? Text(widget.account.accountNum!.toString(),
                    style: TextStyle(
                      fontSize: fontsize,
                      fontWeight: FontWeight.w500,
                    ),
                  ) : Divider(),
                  SizedBox(height:10),


                ],
              ),
            ),
            Container(
              height: 80,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.7),
                    ),
                    const BoxShadow(
                      color: Color(0xFFF4F4F4),
                      spreadRadius: -2.0,
                      blurRadius: 4.0,
                    )
                  ]
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      width:size.width*0.44,
                      height: 55,
                      margin: EdgeInsets.only(left:15),
                      child: OutlinedButton(
                          onPressed: (){
                            provider.accounts.remove(widget.account);
                            provider.accounts.insert(0,widget.account);

                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            side: const BorderSide(
                              color: Color(0xFFD9D9D9),
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
                      width:size.width*0.44,
                      height: 55,
                      margin: EdgeInsets.only(right:15),
                      child: OutlinedButton(
                          onPressed: (){
                            setState(() {
                              provider.deleteAccount(widget.account, provider.accounts.indexOf(widget.account));
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: color1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            side: const BorderSide(
                              color: Colors.transparent
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
            ),
          ],
        ),
      ),
    );
  }
}
