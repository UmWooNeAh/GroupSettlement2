import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:groupsettlement2/view/shared_basic_widget.dart';
import 'package:flutter/services.dart';

import '../class/class_account.dart';
import '../design_element.dart';
import '../viewmodel/UserViewModel.dart';
class MyPage extends ConsumerStatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  ConsumerState<MyPage> createState() => _MyPageState();
}

class _MyPageState extends ConsumerState<MyPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var uvm = ref.watch(userProvider);
    Account mainAccount = uvm.accounts.first;
    String inputName = "";
    return Scaffold(
        body:SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height:60),
              Container(
                margin: const EdgeInsets.only(right:20),
                alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: (){},
                    child: Icon(Icons.settings)
                  )
              ),
              Container(
                margin: EdgeInsets.only(left:20),
                child: const Text("마이 프로필",
                  style:TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600
                  )
                ),
              ),
              const SizedBox(height:20),
              Container(
                margin: EdgeInsets.only(left:20),
                child: Row(
                  children: [
                    CircleAvatar(minRadius: 45,),
                    SizedBox(width:size.width*0.05),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: uvm.userData.name!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20,
                                    )
                                  ),
                                  const TextSpan(
                                    text: " 님",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600
                                    )
                                  ),
                                ]
                              )
                            ),
                            SizedBox(width: size.width*0.02),
                            GestureDetector(
                              onTap: () => showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text("이름 변경"),
                                  content: TextField(
                                    onChanged: (value) {
                                      inputName = value;
                                    },
                                  ),
                                  actionsAlignment: MainAxisAlignment.spaceBetween,
                                  actions: [
                                    SizedBox(
                                      height: 50,
                                      child: OutlinedButton(
                                        onPressed: () {
                                          if(inputName == ""){
                                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                              content: Text(
                                                  '이름은 공백이 될 수 없습니다.'),
                                              duration: Duration(seconds: 3),
                                            ));
                                            return;
                                          }
                                          Navigator.of(context).pop();
                                          setState(() {
                                            uvm.editUsername(inputName);
                                          });
                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                            content: Text(
                                                '성공적으로 이름을 변경했습니다.'),
                                            duration: Duration(seconds: 3),
                                          ));
                                        },
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: color2,
                                          side: const BorderSide(
                                            color: color2,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                        ),
                                        child: const Text(
                                          "변경된 이름 저장",
                                          style: TextStyle(
                                              fontSize: 15, color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 50,
                                      child: OutlinedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                          side: const BorderSide(
                                            color: Colors.grey,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                        child: const Text(
                                          "취소",
                                          style: TextStyle(
                                              fontSize: 15, color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              child: SizedBox(
                                width: 15,
                                height: 15,
                                child: Image.asset('images/editGroupName.png'),
                              ),
                            )
                          ],
                        ),
                        Text("[친구찾기 닉네임]",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          )
                        )
                      ],
                    ),

                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Divider(thickness: 10,color: Color(0xFFF4F4F4),),
              const SizedBox(height: 20),
              Container(
                margin: EdgeInsets.only(left:20,right:20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    const Text("내 계좌",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20
                      )
                    ),
                    GestureDetector(
                      onTap:(){
                        context.push("/MyPage/AccountDetail");
                      },
                      child:const Text(
                        "자세히 보기>",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Divider(thickness: 1),
              ),
              uvm.userData.accountInfo.isNotEmpty ? Container(
                margin: EdgeInsets.only(left:20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: ()async{
                        await Clipboard.setData(ClipboardData(text: uvm.accounts.first.accountNum.toString()));
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: const Center(
                            child: Text(
                                '계좌번호가 복사되었습니다.'),
                          ),
                          duration: const Duration(milliseconds: 1500),
                          width: size.width*0.5,
                          backgroundColor: color1,
                          shape: StadiumBorder(),
                          behavior: SnackBarBehavior.floating,
                        ));
                      },
                      child: Text(mainAccount.bank!+" "+mainAccount.accountNum.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          decoration: TextDecoration.underline

                        ),
                      ),
                    ),
                    Text(mainAccount.accountAlias!,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600
                      ),
                    )
                  ],
                ),
              ) : const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(child:Text("현재 등록된 계좌가 없습니다.",
                  style: TextStyle(
                    color: Color(0xFF766E6E),
                    fontWeight: FontWeight.w500,
                    fontSize: 15
                  ),
                )),
              ),
              const SizedBox(height:15),
              Center(
                child: Container(
                  width:size.width*0.9,
                  height:60,
                  decoration: BoxDecoration(
                    border: Border.all(width:0.5,color: const Color(0xFFD9D9D9)),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: OutlinedButton(
                    onPressed: () {
                      context.push('/MyPage/AddAccount');
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Color(0xFFCCCCCC),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "계좌 추가하기",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  )
                ),

              const SizedBox(height:40),
              const Divider(thickness: 10,color: Color(0xFFF4F4F4)),
              const SizedBox(height:20),

            ],
          ),
        ),
        bottomNavigationBar: const CustomBottomNavigationBar(
          index: 4,
          isIn: true,
        ),
    );
  }
}
