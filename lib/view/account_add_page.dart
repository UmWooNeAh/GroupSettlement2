import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groupsettlement2/view/shared_basic_widget.dart';
import 'package:groupsettlement2/viewmodel/UserViewModel.dart';

import '../class/class_account.dart';
import '../design_element.dart';

class AccountAddPage extends ConsumerStatefulWidget {
  const AccountAddPage({Key? key}) : super(key: key);

  @override
  ConsumerState<AccountAddPage> createState() => _AccountAddPageState();
}

class _AccountAddPageState extends ConsumerState<AccountAddPage> {
  final List<String> _banks = ["하나은행","국민은행","외환은행","기업은행","부산은행","신한은행","대구은행"];
  String? bank;
  bool _makeFavorite = false;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    String accountNum = ""; String ownerName = "";
    final provider = ref.watch(userProvider);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            Center(
              child: Container(
                color: Colors.white,
              ),
            ),
            Positioned(
              top: -size.height * 0.2,
              left: size.width * 0.75,
              child: Transform.rotate(
                angle: pi * 3 / 4,
                child: Container(
                  height: size.width * 1.7,
                  width: size.width,
                  decoration: BoxDecoration(
                    color: color1,
                    borderRadius: BorderRadius.circular(20)
                  ),
                ),
              ),
            ),
            Positioned(
              top: size.height * 0.4,
              right: size.width * 0.75,
              child: Transform.rotate(
                angle: pi * 3 / 4,
                child: Container(
                  height: size.width * 1.7,
                  width: size.width,
                  decoration: BoxDecoration(
                      color: color2,
                      borderRadius: BorderRadius.circular(20)
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left:20,right:20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height:size.height*0.12),
                    Text("계좌를 등록합니다.",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height:size.height*0.12),
                    Text("은행사를 선택해주세요.",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    Container(
                      width: size.width*0.9,
                      child: DropdownButton(
                          isExpanded: true,

                          value: bank,
                          items: _banks.map((e)=>
                              DropdownMenuItem(child: Text(e),value: e,)).toList(),
                          hint:Text("은행사명"),
                          onChanged: (val){
                            setState(() {
                              bank = val!;
                              print(bank);
                            });
                          },
                      ),
                    ),
                    SizedBox(height:20),
                    Text("계좌 번호를 입력해주세요.",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    TextField(
                      onChanged: (val){
                        accountNum = val;
                      },
                    ),
                    SizedBox(height:20),
                    Text("예금주를 입력해주세요.",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    TextField(
                      onChanged: (val){
                        ownerName = val;
                      },
                    ),
                    ListTileTheme(
                      horizontalTitleGap: 0.0,
                      child: CheckboxListTile(
                          value: _makeFavorite,
                          title:Text("이 계좌를 대표 계좌로 설정합니다."),
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                          dense : true,
                          activeColor: Colors.black,
                          onChanged: (val){
                            setState(() {
                              _makeFavorite = !_makeFavorite;
                            });
                          }
                      ),
                    ),
                    SizedBox(height:50),
                    Container(
                      width:size.width*0.9,
                      height: 60,
                      margin: EdgeInsets.only(bottom: 20),
                      child: OutlinedButton(
                          onPressed: (){
                            // Account account = Account();
                            // account.accountNum = accountNum;
                            // account.accountAlias = ;
                            // account.accountHolder = ownerName;
                            // account.bank = bank;
                            // provider.addAccount(account);
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Color(0xFF454545),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text("계좌 등록하기",
                            style: TextStyle(
                              color:Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ))
                    ),

                  ],
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(
        index: 0,
        isIn: true,
      ),
    );
  }
}
