import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class myPage extends StatefulWidget {
  const myPage({Key? key}) : super(key: key);

  @override
  State<myPage> createState() => _myPageState();
}

class _myPageState extends State<myPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation:0.0,
        ),
        body:SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left:20),
                child: Text("마이 프로필",
                  style:TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600
                  )
                ),
              ),
              SizedBox(height:20),
              Padding(
                padding: const EdgeInsets.only(left:20),
                child: Row(
                  children: [
                    CircleAvatar(minRadius: 45,),
                    SizedBox(width:size.width*0.05),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "주드벨링엄",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            )
                          ),
                          TextSpan(
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
                    Image.asset('images/editGroupName.png', width: 20, height: 20)
                  ],
                ),
              ),
              SizedBox(height: 20),
              Divider(thickness: 10,color: Color(0xFFF4F4F4)),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left:20),
                child: Text("내 계좌",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20
                  )
                )
              ),
              Padding(
                padding: const EdgeInsets.only(left:20,right:20),
                child: Divider(thickness: 1),
              ),
              SizedBox(height:10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left:20),
                    child: CircleAvatar(
                      backgroundColor: Color(0xFFFFC93D),
                      minRadius: 30,
                      child: Text("국민",
                        style: TextStyle(
                          color:Colors.white,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right:20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("123-456789-XXX-X",
                          style:TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          )
                        ),
                        Text("신성민",
                          style:TextStyle(
                            fontSize:15,
                            fontWeight: FontWeight.w500
                          )
                        )
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height:30),
              Center(
                child: Container(
                  width:size.width*0.9,
                  height:50,
                  decoration: BoxDecoration(
                    border: Border.all(width:1.5,color: Color(0xFFD9D9D9)),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Center(
                    child: Text("계좌 추가하기",
                      style: TextStyle(
                        fontWeight: FontWeight.w500
                      )
                    ),
                  )
                ),
              ),
              SizedBox(height:40),
              Divider(thickness: 10,color: Color(0xFFF4F4F4)),
              SizedBox(height:20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left:20),
                    child: Text("진행 중인 정산",
                      style:TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18
                      )
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right:20,top:10),
                    child: Text("자세히 보기>",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 13
                      )
                    )
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left:20,right:20),
                child: Divider(thickness: 1),
              ),
              SizedBox(height:10),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left:20),
                    child: Text("그룹1",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600
                      )
                    ),
                  ),
                  SizedBox(width:size.width*0.05),
                  Container(
                    width: size.width*0.5,
                    child: Stack(
                      children: [
                        Positioned(
                          child: Container(
                            width:size.width*0.05,
                            height:size.width*0.05,
                            decoration: BoxDecoration(
                              color:Colors.grey,
                              shape:BoxShape.circle,
                            ),
                          ),
                        ),
                        Positioned(
                          left:size.width*0.03,
                          child: Container(
                            width:size.width*0.05,
                            height:size.width*0.05,
                            decoration: BoxDecoration(
                              color:Colors.grey,
                              shape:BoxShape.circle,
                            ),
                          ),
                        ),
                        Positioned(
                          left:size.width*0.06,
                          child: Container(
                            width:size.width*0.05,
                            height:size.width*0.05,
                            decoration: BoxDecoration(
                              color:Colors.grey,
                              shape:BoxShape.circle,
                            ),
                          ),
                        ),
                        Positioned(
                          left:size.width*0.09,
                          child: Container(
                            width:size.width*0.05,
                            height:size.width*0.05,
                            decoration: BoxDecoration(
                              color:Colors.grey,
                              shape:BoxShape.circle,
                            ),
                          ),
                        ),
                        Positioned(
                          left:size.width*0.15,
                          child: Text("+2")
                        )
                      ],
                    ),
                  ),
                  SizedBox(width:size.width*0.2),
                  Container(
                    width: size.width*0.03,
                    height: size.width*0.03,
                    decoration: BoxDecoration(
                        color: Color(0xFF07BEB8),
                        shape: BoxShape.circle
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left:20,top:5),
                child: Text("20230701 정산이 진행중입니다.",
                  style: TextStyle(
                    color: Color(0xFF07BEB8),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left:20,right:20),
                child: Divider(thickness: 1),
              ),
              SizedBox(height:10),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left:20),
                    child: Text("그룹2",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600
                        )
                    ),
                  ),
                  SizedBox(width:size.width*0.05),
                  Container(
                    width: size.width*0.5,
                    child: Stack(
                      children: [
                        Positioned(
                          child: Container(
                            width:size.width*0.05,
                            height:size.width*0.05,
                            decoration: BoxDecoration(
                              color:Colors.grey,
                              shape:BoxShape.circle,
                            ),
                          ),
                        ),
                        Positioned(
                          left:size.width*0.03,
                          child: Container(
                            width:size.width*0.05,
                            height:size.width*0.05,
                            decoration: BoxDecoration(
                              color:Colors.grey,
                              shape:BoxShape.circle,
                            ),
                          ),
                        ),
                        Positioned(
                          left:size.width*0.06,
                          child: Container(
                            width:size.width*0.05,
                            height:size.width*0.05,
                            decoration: BoxDecoration(
                              color:Colors.grey,
                              shape:BoxShape.circle,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(width:size.width*0.15),
                  Container(
                    width: size.width*0.03,
                    height: size.width*0.03,
                    decoration: BoxDecoration(
                        color: Color(0xFFFE5F55),
                        shape: BoxShape.circle
                    ),
                  ),
                  SizedBox(width:size.width*0.02),
                  Container(
                    width: size.width*0.03,
                    height: size.width*0.03,
                    decoration: BoxDecoration(
                        color: Color(0xFF07BEB8),
                        shape: BoxShape.circle
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left:20,top:5),
                child: Text("계모임 정산이 진행중입니다.",
                  style: TextStyle(
                    color: Color(0xFFFE5F55),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left:20),
                child: Text("흑우팸 정산이 진행중입니다.",
                  style: TextStyle(
                    color: Color(0xFF07BEB8),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left:20,right:20),
                child: Divider(thickness: 1),
              ),
              SizedBox(height:10),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left:20),
                    child: Text("그룹3",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600
                        )
                    ),
                  ),
                  SizedBox(width:size.width*0.05),
                  Container(
                    width: size.width*0.5,
                    child: Stack(
                      children: [
                        Positioned(
                          child: Container(
                            width:size.width*0.05,
                            height:size.width*0.05,
                            decoration: BoxDecoration(
                              color:Colors.grey,
                              shape:BoxShape.circle,
                            ),
                          ),
                        ),
                        Positioned(
                          left:size.width*0.03,
                          child: Container(
                            width:size.width*0.05,
                            height:size.width*0.05,
                            decoration: BoxDecoration(
                              color:Colors.grey,
                              shape:BoxShape.circle,
                            ),
                          ),
                        ),
                        Positioned(
                          left:size.width*0.06,
                          child: Container(
                            width:size.width*0.05,
                            height:size.width*0.05,
                            decoration: BoxDecoration(
                              color:Colors.grey,
                              shape:BoxShape.circle,
                            ),
                          ),
                        ),
                        Positioned(
                          left:size.width*0.09,
                          child: Container(
                            width:size.width*0.05,
                            height:size.width*0.05,
                            decoration: BoxDecoration(
                              color:Colors.grey,
                              shape:BoxShape.circle,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left:20,top:5),
                child: Text("진행중인 정산이 없습니다.",
                ),
              ),
              SizedBox(width:double.infinity,height:30),
              Divider(thickness: 10,color: Color(0xFFF4F4F4)),
              SizedBox(width:double.infinity,height:30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left:20),
                    child: Text("알림",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right:20),
                    child: Text("자세히 보기>",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left:20,right:20),
                child: Divider(thickness: 1),
              ),
              SizedBox(height:10),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left:20),
                    child: Container(
                      width: size.width*0.03,
                      height: size.width*0.03,
                      decoration: BoxDecoration(
                          color: Color(0xFF07BEB8),
                          shape: BoxShape.circle
                      ),
                    ),
                  ),
                  SizedBox(width:20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("보낼 정산",
                        style:TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        )
                      ),
                      Text("송금을 기다리고 있는 유저들이 있어요!",
                        style:TextStyle(
                          fontSize:12,
                          color: Color(0xFF7C7C7C),
                        )
                      )
                    ],
                  ),
                  SizedBox(width:size.width*0.28),
                  Text("3",
                    style:TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize:20,
                      color: Color(0xFF07BEB8),
                    )
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left:20,right:20),
                child: Divider(thickness: 2,color: Color(0xFF07BEB8)),
              ),
              SizedBox(height:10),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left:20),
                    child: Container(
                      width: size.width*0.03,
                      height: size.width*0.03,
                      decoration: BoxDecoration(
                          color: Color(0xFFFE5F55),
                          shape: BoxShape.circle
                      ),
                    ),
                  ),
                  SizedBox(width:20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("받을 정산",
                          style:TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          )
                      ),
                      Text("송금 현황을 확인해 볼까요?",
                          style:TextStyle(
                            fontSize:12,
                            color: Color(0xFF7C7C7C),
                          )
                      )
                    ],
                  ),
                  SizedBox(width:size.width*0.42),
                  Text("5",
                      style:TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize:20,
                        color: Color(0xFFFE5F55),
                      )
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left:20,right:20),
                child: Divider(thickness: 2,color: Color(0xFFFE5F55)),
              ),
              SizedBox(height:10),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left:20),
                    child: Container(
                      width: size.width*0.03,
                      height: size.width*0.03,
                      decoration: BoxDecoration(
                          color: Color(0xFF565659),
                          shape: BoxShape.circle
                      ),
                    ),
                  ),
                  SizedBox(width:20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("기타 알림",
                          style:TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          )
                      ),
                      Text("다른 알림들을 볼까요??",
                          style:TextStyle(
                            fontSize:12,
                            color: Color(0xFF7C7C7C),
                          )
                      )
                    ],
                  ),
                  SizedBox(width:size.width*0.47),
                  Text("5",
                      style:TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize:20,
                        color: Color(0xFF565659),
                      )
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left:20,right:20),
                child: Divider(thickness: 2,color: Color(0xFF565659)),
              ),
              SizedBox(height:80)
            ],
          ),
        )
    );
  }
}
