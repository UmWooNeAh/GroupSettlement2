import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class groupSettlementListPage extends StatefulWidget {
  const groupSettlementListPage({Key? key}) : super(key: key);

  @override
  State<groupSettlementListPage> createState() => _groupSettlementListPageState();
}

class _groupSettlementListPageState extends State<groupSettlementListPage> {
  var _containerWidth;
  bool flag = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    _containerWidth = flag ? size.width*0.05 : size.width*0.15;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation:0.0,
      ),
      body: Column(
        children: [
          Row(
            children: [
              SizedBox(width:size.width * 0.05),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  Text("엄우네아",
                    style:TextStyle(

                    ),
                  ),
                  Text("정산 목록",
                    style:TextStyle(
                      fontSize:20,
                      fontWeight: FontWeight.w700
                    )
                  ),
                ]
              ),
              SizedBox(width: size.width * 0.35),
              GestureDetector(
                onTap:(){
                  setState((){
                    flag = !flag;
                  });
                },
                child: Container(
                  width: size.width * 0.35, height: 55,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1.2, color:Color(0xFFD9D9D9)),
                      borderRadius: BorderRadius.circular(5)
                    )
                  ),
                  child:Center(
                    child: Text("정산 합치기",
                      style:TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600
                      )
                    )
                  )
                ),
              ),
              SizedBox(width:size.width * 0.05)
            ],
          ),
          SizedBox(width: double.infinity,height: 30),
          Align(
            alignment: Alignment(0.8,1),
            child: GestureDetector(
              child:Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "이름순",
                      style: TextStyle(
                        //fontSize:20,
                        color: Color(0xFF838383)
                      )
                    ),
                    TextSpan(
                      text: "▼",
                      style: TextStyle(
                        fontSize:15,
                        color: Color(0xFF838383),
                      )
                    )
                  ]
                )
              )
            ),
          ),
          SizedBox(width:double.infinity,height: 30),
          GestureDetector(
            onTap:(){
              //context.push("/settlementDetailPage");
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 400),
              margin: EdgeInsets.only(left:_containerWidth,right:size.width*0.05),
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(width: 3, color: Color(0xFFFE5F55)),
                ),
                shadows: [
                  BoxShadow(
                    color: Color(0x3F000000),
                    blurRadius: 2,
                    offset: Offset(0, 5),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: Column(children: [
                Container(
                    width: double.infinity,
                    height: 23,
                    color: Color(0xFFFE5F55),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left:10),
                          child: Text("받을 정산",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right:10),
                          child: Text("2023-08-19",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400
                              )
                          ),
                        )
                      ],
                    )),
                Container(
                  width: double.infinity,
                  height: 70,
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
                        alignment: Alignment(-0.9, 0),
                        child: Text(
                          "정산 1",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w700),
                        ),
                      ),
                      Align(
                        alignment: Alignment(0.9, 0),
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

                    ],
                  ),
                ),
              ]),
            ),
          ),
          SizedBox(width:double.infinity,height:40),
          GestureDetector(
            onTap:(){
              //context.push("/settlementDetailPage");
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 400),
              margin: EdgeInsets.only(left:_containerWidth,right:size.width*0.05),
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(width: 3, color: Color(0xFF07BEB8)),
                ),
                shadows: [
                  BoxShadow(
                    color: Color(0x3F000000),
                    blurRadius: 2,
                    offset: Offset(0, 5),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: Column(children: [
                Container(
                    width: double.infinity,
                    height: 23,
                    //margin: const EdgeInsets.only(left:20,right:20),
                    color: Color(0xFF07BEB8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left:10),
                          child: Text("보낼 정산",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right:10),
                          child: Text("2023-08-19",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400
                              )
                          ),
                        )
                      ],
                    )),
                Container(
                  width: size.width,
                  height: 70,
                  //margin: const EdgeInsets.only(left:20,right:20),
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
                        alignment: Alignment(-0.9, 0),
                        child: Text(
                          "정산 2",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w700),
                        ),
                      ),
                      Align(
                        alignment: Alignment(0.9, 0),
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '4',
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

                    ],
                  ),
                ),
              ]),
            ),
          ),
          SizedBox(width:double.infinity,height:40),
          GestureDetector(
            onTap:(){
              //context.push("/settlementDetailPage");
            },
            child: Stack(
              children: [
                Align(
                  alignment:Alignment(0.45,0),
                  child: AnimatedContainer(
                    width: double.infinity,
                    height: 118,
                    duration: Duration(milliseconds: 400),
                    margin: EdgeInsets.only(left:_containerWidth+50,right:size.width*0.05),
                    decoration: ShapeDecoration(
                        color: Color(0xFFCECECE),
                        shape:RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        )
                    ),
                  ),
                ),
                Align(
                  alignment:Alignment(0.22,0),
                  child: AnimatedContainer(
                    width: double.infinity,
                    height: 108,
                    duration: Duration(milliseconds: 400),
                    margin: EdgeInsets.only(left:_containerWidth+25,right:size.width*0.05),
                    decoration: ShapeDecoration(
                      color: Color(0xFF929292),
                      shape:RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 400),
                    margin: EdgeInsets.only(left:_containerWidth,right:size.width*0.05),
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(width: 3, color: Color(0xFF07BEB8)),
                      ),
                      shadows: [
                        BoxShadow(
                          color: Color(0x3F000000),
                          blurRadius: 2,
                          offset: Offset(0, 5),
                          spreadRadius: 0,
                        )
                      ],
                    ),
                    child: Column(children: [
                      Container(
                          width: double.infinity,
                          height: 23,
                          color: Color(0xFF07BEB8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left:10),
                                child: Text("합쳐진 정산",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left:10),
                                child: Text("2023-08-19",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400
                                    )
                                ),
                              )
                            ],
                          )
                      ),
                      Container(
                        width: double.infinity,
                        height: 70,
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
                              alignment: Alignment(-0.9, 0),
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text:"정산 3",
                                      style: TextStyle(
                                          fontSize: 25, fontWeight: FontWeight.w700),
                                    ),
                                    TextSpan(
                                      text:" 등 2개",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color:Color(0xFF838383)
                                      )
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment(0.9, 0),
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '4',
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

                          ],
                        ),
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width:double.infinity,height:30),
          GestureDetector(
            onTap:(){
              //context.push("/settlementDetailPage");
            },
            child: AnimatedContainer(
              // width: 198,
              // height: 256,
              duration: Duration(milliseconds: 400),
              margin: EdgeInsets.only(left:_containerWidth,right:size.width*0.05),
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(width: 3, color: Color(0xFF07BEB8)),
                ),
                shadows: [
                  BoxShadow(
                    color: Color(0x3F000000),
                    blurRadius: 2,
                    offset: Offset(0, 5),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: Column(children: [
                Container(
                    width: double.infinity,
                    height: 23,
                    color: Color(0xFF07BEB8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left:10),
                          child: Text("보낼 정산",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right:10),
                          child: Text("2023-08-19",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400
                              )
                          ),
                        )
                      ],
                    )),
                Container(
                  width: double.infinity,
                  height: 70,
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
                        alignment: Alignment(-0.9, 0),
                        child: Text(
                          "정산 4",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w700),
                        ),
                      ),
                      Align(
                        alignment: Alignment(0.9, 0),
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '4',
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

                    ],
                  ),
                ),
              ]),
            ),
          ),
        ],
      )
    );
  }
}
