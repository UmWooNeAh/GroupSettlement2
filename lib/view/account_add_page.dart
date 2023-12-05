import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  String accountNum = ""; String ownerName = ""; String accountNickname = "";
  bool _makeFavorite = false;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

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
                    SizedBox(height:size.height*0.06),
                    Text("계좌 별명을 입력해주세요.",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    TextField(
                      decoration: InputDecoration(
                        hintText: "계좌 별명",
                      ),
                      onChanged: (val){
                        accountNickname = val;
                      },
                    ),
                    SizedBox(height:20),
                    Text("은행사를 선택해주세요.",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    Container(
                      width: size.width*0.4,
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
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: InputDecoration(
                        hintText: "계좌번호 ('-'기호를 제외하고 입력\)",
                      ),
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
                      controller: TextEditingController()..text = provider.userData.name!,
                      decoration: InputDecoration(
                        hintText: "예금주",
                      ),
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
                          checkboxShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100)
                          ),
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
                            Account account = Account();
                            try{
                              account.accountNum = int.parse(accountNum);
                            }catch(e){
                              print(e);
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content: Text(
                                    '계좌번호에는 숫자만 넣어주세요.'),
                                duration: Duration(seconds: 2),
                              ));
                              return;
                            }
                            account.accountAlias = accountNickname;
                            account.accountHolder = ownerName;
                            account.bank = bank;

                            provider.addAccount(account,_makeFavorite);
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text(
                                  '성공적으로 계좌를 등록했어요.'),
                              duration: Duration(seconds: 2),
                            ));
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
