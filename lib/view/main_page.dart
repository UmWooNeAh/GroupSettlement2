import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groupsettlement2/view/shared_basic_widget.dart';

import '../design_element.dart';

class mainPage extends ConsumerStatefulWidget {
  const mainPage({Key? key}) : super(key: key);

  @override
  ConsumerState<mainPage> createState() => _mainPageState();
}

class _mainPageState extends ConsumerState<mainPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height:20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right:10),
                  child: CircleAvatar(),
                ),
                Text("Y'EMON"),
              ],
            ),
            Divider(thickness: 5,color:Color(0xFFF4F4F4)),
            Padding(
              padding: const EdgeInsets.only(left:20,right:20),
              child: Container(
                width:double.infinity,
                height: 200,
                child: Center(
                  child: Text("문구 들어갈 위치",
                    style:TextStyle(
                      color:Colors.red,
                      fontWeight: FontWeight.w600,
                      fontSize: 15
                    )
                  ),
                )
              ),
            ),
            Container(
              width:double.infinity,
              height:160,
              decoration: BoxDecoration(
                color:Color(0xFFF4F4F4)
              ),
              child:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:[
                    Padding(
                      padding: const EdgeInsets.only(left:15,top:15),
                      child: Text("단순 정산기",
                        style:TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        )
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left:15,right:15,top:10,bottom:10),
                      child: Container(
                        width: double.infinity,
                        height: 85,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color:Color(0xFF07BEB8),width:3),
                          color:Colors.white
                        ),
                        child:
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(8,8,16,8),
                                  child: Column(
                                    children: [
                                      Text("총 금액",
                                        style:TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                        )
                                      ),
                                      SizedBox(height:5),
                                      Text("9,999,999 원",
                                        style:TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 18,
                                        )
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(16,8,16,8),
                                  child: Column(
                                    children: [
                                      Text("사람 수",
                                          style:TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18,
                                          )
                                      ),
                                      SizedBox(height:5),
                                      Text("99 명",
                                          style:TextStyle(
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xFF838383),
                                            fontSize: 18,
                                          )
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left:30),
                                  child: GestureDetector(
                                    child:
                                      Container(
                                        width: size.width * 0.25,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: Color(0xFF454545),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Center(
                                          child: Text("계산하기",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15
                                            )
                                          ),
                                        ),
                                      )
                                  ),
                                )
                              ],
                            ),
                          )
                      ),
                    )
                  ]
                )
            ),
            SizedBox(height:20),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left:10,right:10),
                  child: GestureDetector(
                    onTap: (){},
                    child: Container(
                      width: size.width * 0.45,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Color(0xFFD9D9D9)
                        )
                      ),
                      child:Center(
                        child: Padding(
                          padding: const EdgeInsets.only(right:40),
                          child: Text(
                            "카메라로\n영수증 인식하기",
                            style:TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600
                            )
                          ),
                        )
                      )
                    )
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left:10,right:10),
                  child: GestureDetector(
                      onTap: (){},
                      child: Container(
                          width: size.width * 0.45,
                          height: 120,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: Color(0xFFD9D9D9)
                              )
                          ),
                          child:Center(
                              child: Text(
                                  "카메라로\n영수증 인식하기",
                                  style:TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600
                                  )
                              )
                          )
                      )
                  ),
                ),
              ],
            ),
            SizedBox(height:10),
            Padding(
              padding: const EdgeInsets.only(left:10,right:10),
              child: Divider(thickness: 1,color:Color(0xFFD9D9D9)),
            ),
            SizedBox(height:10),
            GestureDetector(
              onTap: (){},
              child: Padding(
                padding: const EdgeInsets.only(left:10,right:10),
                child: Container(
                  width:double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Color(0xFFD9D9D9)
                    )
                  ),
                  child: Center(
                    child:Text("내가 속한 그룹 확인하기",
                      style:TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15
                      )
                    )
                  )
                ),
              )
            ),
            SizedBox(height:10),
            Divider(thickness: 5,color:Color(0xFFF4F4F4)),
            Padding(
              padding: const EdgeInsets.only(left:10,right:10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top:10,bottom:10,left:10),
                    child: Text("최근 정산",
                      style:TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20
                      )
                    ),
                  ),
                  Container(
                    width:double.infinity,
                    height:180,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color:Color(0xFFFE5F55)
                      ),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child:Stack(
                      children: [
                        Positioned(
                          left:size.width*0.75,
                          bottom:150,
                          child: Padding(
                            padding: const EdgeInsets.only(right:15,top:15),
                            child: Text("2023-08-19",
                              style:TextStyle(
                                color: Colors.grey
                              )
                            ),
                          ),
                        ),
                        Positioned(
                          top:10,
                          child: Padding(
                            padding: const EdgeInsets.only(left:15),
                            child: Row(
                              children: [
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text:"보낼 정산\n",
                                        style: TextStyle(
                                          color: Color(0xFFFE5F55),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600
                                        )
                                      ),
                                      TextSpan(
                                        text:"정산1",
                                        style:TextStyle(
                                          fontSize:20,
                                          fontWeight: FontWeight.w700
                                        )
                                      )
                                    ]
                                  )
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top:25),
                                  child: Text("UWNA",
                                    style: TextStyle(
                                      color: Colors.grey
                                    )
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top:125,
                          left:10,
                          child: Row(
                            children: [
                              Text("정산 현황",
                                style:TextStyle(
                                  color: Colors.grey
                                )
                              ),
                              Container(
                                margin: const EdgeInsets.fromLTRB(13, 20, 20, 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Stack(
                                      children: [
                                        Container(
                                          height: 20,
                                          width: size.width*0.7,
                                          decoration: BoxDecoration(
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Colors.grey,
                                                blurRadius: 2,
                                              ),
                                              BoxShadow(
                                                color: Colors.grey,
                                                blurRadius: 2,
                                              ),
                                            ],
                                            color: Colors.grey[300],
                                            borderRadius: BorderRadius.circular(50),
                                          ),
                                        ),
                                        Container(
                                          height: 20,
                                          width: size.width * 0.45,
                                          decoration: BoxDecoration(
                                            color: color1,
                                            borderRadius: BorderRadius.circular(50),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Colors.grey,
                                                blurRadius: 2,
                                                offset: Offset(2, 2),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                          width: size.width,
                                          child: const Align(
                                              alignment: Alignment(-0.95, 0.0),
                                              child: Text(
                                                "${60}%",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              )),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ),
                  SizedBox(height:100)
                ],
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
