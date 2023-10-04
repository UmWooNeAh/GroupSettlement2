import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../design_element.dart';

class groupMainPage extends StatefulWidget {
  const groupMainPage({Key? key}) : super(key: key);

  @override
  State<groupMainPage> createState() => _State();
}

class _State extends State<groupMainPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(),
        body:
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(left:15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //SizedBox(height: 50),
                    Text(
                      "그룹",
                      style: TextStyle(
                          color: Color(0xFF454545),
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          height: 0),
                    ),
                    Row(children: [
                      Text(
                        "엄우네아",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            height: 0),
                      ),
                      SizedBox(width: 10),
                      Image.asset('images/editGroupName.png', width: 20, height: 20)
                    ]),
                    SizedBox(height:15),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text.rich(
                        TextSpan(
                        children:[
                          TextSpan(
                            text:"진행 중인 정산",
                            style:TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w700
                            )
                          ),
                          TextSpan(
                            text:"   ",
                          ),
                          TextSpan(
                            text:"3",
                            style: TextStyle(
                              color: Color(0xFFFE5F55),
                              fontSize: 25,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ]
                        )
                      ),
                      Padding(
                        padding: EdgeInsets.only(right:10),
                        child: GestureDetector(
                          onTap:(){
                            context.push("/groupSettlementListPage");
                          },
                          child: Text(
                            '자세히 보기 >',
                            style: TextStyle(
                              color: Color(0xFF454545),
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              height: 0,
                            ),
                          ),
                        ),
                      )
                    ]),
                    SizedBox(height:10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap:(){
                              context.push("/settlementDetailPage");
                            },
                            child: Container(
                              // width: 198,
                              // height: 256,
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(width: 3, color: Color(0xFFFE5F55)),
                                ),
                                shadows: [
                                  BoxShadow(
                                    color: Color(0x3F000000),
                                    blurRadius: 5,
                                    offset: Offset(0, 5),
                                    spreadRadius: 0,
                                  )
                                ],
                              ),
                              child: Column(children: [
                                Container(
                                    width: size.width * 0.4,
                                    height: 23,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFFE5F55),
                                    ),
                                    child: Align(
                                        alignment: Alignment(-0.9, 0),
                                        child: Text("보낼 정산",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600)))),
                                Container(
                                  width: size.width * 0.4,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10)
                                    )
                                  ),
                                  child: Stack(
                                    children: [
                                      Align(
                                        alignment: Alignment(-0.75, -0.85),
                                        child: Text(
                                          "정산 1",
                                          style: TextStyle(
                                              fontSize: 25, fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment(0.9, 0.65),
                                        child: Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text: '4',
                                                style: TextStyle(
                                                  color: Color(0xFFFE5F55),
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                              TextSpan(
                                                text: ' / 8명',
                                                style: TextStyle(
                                                  color: Color(0xFF838383),
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment(0.9, 0.9),
                                        child: Text(
                                          "2023-08-19",
                                          style: TextStyle(
                                            color: Color(0xFF838383),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                            ),
                          ),
                          SizedBox(width: 15),
                          Container(
                            // width: 198,
                            // height: 256,
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(width: 3, color: Color(0xFF07BEB8)),
                              ),
                              shadows: [
                                BoxShadow(
                                  color: Color(0x3F000000),
                                  blurRadius: 5,
                                  offset: Offset(0, 5),
                                  spreadRadius: 0,
                                )
                              ],
                            ),
                            child: Column(children: [
                              Container(
                                  width: size.width * 0.4,
                                  height: 23,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF07BEB8),
                                  ),
                                  child: Align(
                                      alignment: Alignment(-0.9, 0),
                                      child: Text("보낼 정산",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600)))),
                              Container(
                                width: size.width * 0.4,
                                height: 200,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10)
                                  )
                                ),
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment(-0.75, -0.85),
                                      child: Text(
                                        "정산 2",
                                        style: TextStyle(
                                            fontSize: 25, fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment(0.9, 0.65),
                                      child: Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: '1',
                                              style: TextStyle(
                                                color: Color(0xFF07BEB8),
                                                fontSize: 25,
                                                fontWeight: FontWeight.w600,
                                                height: 0,
                                              ),
                                            ),
                                            TextSpan(
                                              text: ' / 8명',
                                              style: TextStyle(
                                                color: Color(0xFF838383),
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600,
                                                height: 0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment(0.9, 0.9),
                                      child: Text(
                                        "2023-08-19",
                                        style: TextStyle(
                                          color: Color(0xFF838383),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                          ),
                          SizedBox(width: 15),
                          Container(
                            // width: 198,
                            // height: 256,
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(width: 3, color: Color(0xFF454545)),
                              ),
                              shadows: [
                                BoxShadow(
                                  color: Color(0x3F000000),
                                  blurRadius: 5,
                                  offset: Offset(0, 5),
                                  spreadRadius: 0,
                                )
                              ],
                            ),
                            child: Column(children: [
                              Container(
                                  width: size.width * 0.4,
                                  height: 23,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF454545),
                                  ),
                                  child: Align(
                                      alignment: Alignment(-0.9, 0),
                                      child: Text("보낼 정산",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600)))),
                              Container(
                                width: size.width * 0.4,
                                height: 200,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10)
                                  )
                                ),
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment(-0.75, -0.85),
                                      child: Text(
                                        "정산 3",
                                        style: TextStyle(
                                            fontSize: 25, fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment(0.9, 0.65),
                                      child: Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: '1',
                                              style: TextStyle(
                                                color: Color(0xFF454545),
                                                fontSize: 25,
                                                fontWeight: FontWeight.w600,
                                                height: 0,
                                              ),
                                            ),
                                            TextSpan(
                                              text: ' / 8명',
                                              style: TextStyle(
                                                color: Color(0xFF838383),
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600,
                                                height: 0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment(0.9, 0.9),
                                      child: Text(
                                        "2023-08-19",
                                        style: TextStyle(
                                          color: Color(0xFF838383),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height:50),
                    Padding(
                      padding: EdgeInsets.only(right:15),
                      child:Divider(thickness: 5,color:Color(0xFFF4F4F4)),
                    ),
                    SizedBox(height:30),
                    Padding(
                      padding: EdgeInsets.only(right:15),
                      child: Container(
                        width: size.width * 0.95,
                        height: 100,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border.all(color: Color(0xFFDADADA)),
                            borderRadius: BorderRadius.circular(10)),

                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: '엄우네아',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    height: 0,
                                  ),
                                ),
                                TextSpan(
                                  text: ' 그룹에서 가장 많이 \n',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    height: 0,
                                  ),
                                ),
                                TextSpan(
                                  text: '정산',
                                  style: TextStyle(
                                    color: Color(0xFFFE5F55),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    height: 0,
                                  ),
                                ),
                                TextSpan(
                                  text: '을 진행한 사람은 ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    height: 0,
                                  ),
                                ),
                                TextSpan(
                                  text: '‘박건우’님',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    height: 0,
                                  ),
                                ),
                                TextSpan(
                                  text: ' 입니다',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    height: 0,
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),

                      ),
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: (){
                        // context.push();
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right:15),
                        child: Container(
                          width: size.width *0.95,
                          height: 65,
                          child:Align(
                            alignment : Alignment.center,
                            child: Text(
                                "새 정산 만들기",
                                textAlign: TextAlign.center,
                                style:TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color:Colors.white,
                                )
                            ),
                          ),
                          decoration: ShapeDecoration(
                            color: Color(0xFF454545),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),

    );
  }
}
