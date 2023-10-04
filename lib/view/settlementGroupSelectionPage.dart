import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class settlementGroupSelectionPage extends StatefulWidget {
  const settlementGroupSelectionPage({Key? key}) : super(key: key);

  @override
  State<settlementGroupSelectionPage> createState() => _settlementGroupSelectionPageState();
}

class _settlementGroupSelectionPageState extends State<settlementGroupSelectionPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar:AppBar(),
      body:Padding(
        padding: const EdgeInsets.only(left: 15,right: 15),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:[
              Text(
                  "정산할 그룹 선택",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  )
              ),
              Align(
                alignment: Alignment.center,
                child: Column(
                  children:[
                    Stack(
                      children: [
                        Positioned(
                          left:15,
                          top: 0,
                          child: Text(
                              "+",
                              style:TextStyle(
                                  fontSize: 35,
                                  color:Color(0xFF838383))
                          ),
                        ),
                        Positioned(
                          child: Container(
                            width: 50, height: 50,
                              decoration: BoxDecoration(
                                border: Border.all(width:2,color:Color(0xFF838383)),
                                shape: BoxShape.circle,
                              )
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:5),
                      child: Text(
                          "새 그룹 만들기",
                          style:TextStyle(
                              color:Color(0xFF838383),
                              fontSize: 15,
                              fontWeight: FontWeight.w500
                          ),
                          textAlign: TextAlign.center,
                      ),
                    ),
                  ]
                ),
              ),
              SizedBox(height:15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:[
                  Row(
                    children:[
                      Container(
                        width: 75, height: 75,
                        decoration: BoxDecoration(
                          color: Color(0xFFFE5F55),
                          shape: BoxShape.circle,
                        ),
                        child:Padding(
                          padding: const EdgeInsets.only(top:17),
                          child: Text(
                              "엄",
                              textAlign: TextAlign.center,
                              style:TextStyle(
                                color:Colors.white,
                                fontSize: 25,
                              )
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:[
                            Text(
                              "엄우네아",
                              style:TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 17
                              )
                            ),
                            SizedBox(height:5),
                            Text(
                              "진행 중인 정산 : 3 개",
                              style: TextStyle(
                                color: Color(0xFFFE5F55),
                                fontWeight: FontWeight.w500,
                              )
                            ),
                          ]
                        ),
                      ),
                    ]
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom:25),
                    child: Text(
                        "2일 전",
                        style:TextStyle(
                          color:Color(0xFF838383),
                        )
                    ),
                  )
                ]
              ),
              Divider(),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:[
                    Row(
                        children:[
                          Container(
                            width: 75, height: 75,
                            decoration: BoxDecoration(
                              color: Color(0xFFD9D9D9),
                              shape: BoxShape.circle,
                            ),
                            child:Padding(
                              padding: const EdgeInsets.only(top:17),
                              child: Text(
                                  "레",
                                  textAlign: TextAlign.center,
                                  style:TextStyle(
                                    color:Colors.white,
                                    fontSize: 25,
                                  )
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left:20),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:[
                                  Text(
                                      "레알마드리드",
                                      style:TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 17
                                      )
                                  ),
                                  SizedBox(height:5),
                                  Text(
                                      "진행 중인 정산 : 3 개",
                                      style: TextStyle(
                                        color: Color(0xFFFE5F55),
                                        fontWeight: FontWeight.w500,
                                      )
                                  ),
                                ]
                            ),
                          ),
                        ]
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom:25),
                      child: Text(
                          "2일 전",
                          style:TextStyle(
                            color:Color(0xFF838383),
                          )
                      ),
                    )
                  ]
              ),
              Divider(),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:[
                    Row(
                        children:[
                          Container(
                            width: 75, height: 75,
                            decoration: BoxDecoration(
                              color: Color(0xFF07BEB8),
                              shape: BoxShape.circle,
                            ),
                            child:Padding(
                              padding: const EdgeInsets.only(top:17),
                              child: Text(
                                  "그",
                                  textAlign: TextAlign.center,
                                  style:TextStyle(
                                    color:Colors.white,
                                    fontSize: 25,
                                  )
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left:20),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:[
                                  Text(
                                      "그룹 1",
                                      style:TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 17
                                      )
                                  ),
                                  SizedBox(height:5),
                                  Text(
                                      "진행 중인 정산 : 3 개",
                                      style: TextStyle(
                                        color: Color(0xFFFE5F55),
                                        fontWeight: FontWeight.w500,
                                      )
                                  ),
                                ]
                            ),
                          ),
                        ]
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom:25),
                      child: Text(
                          "2일 전",
                          style:TextStyle(
                            color:Color(0xFF838383),
                          )
                      ),
                    )
                  ]
              ),
              Divider(),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:[
                    Row(
                        children:[
                          Container(
                            width: 75, height: 75,
                            decoration: BoxDecoration(
                              color: Color(0xFFF7E600),
                              shape: BoxShape.circle,
                            ),
                            child:Padding(
                              padding: const EdgeInsets.only(top:17),
                              child: Text(
                                  "그",
                                  textAlign: TextAlign.center,
                                  style:TextStyle(
                                    color:Colors.white,
                                    fontSize: 25,
                                  )
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left:20),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:[
                                  Text(
                                      "그룹 2",
                                      style:TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 17
                                      )
                                  ),
                                  SizedBox(height:5),
                                  Text(
                                      "진행 중인 정산 : 3 개",
                                      style: TextStyle(
                                        color: Color(0xFFFE5F55),
                                        fontWeight: FontWeight.w500,
                                      )
                                  ),
                                ]
                            ),
                          ),
                        ]
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom:25),
                      child: Text(
                          "2일 전",
                          style:TextStyle(
                            color:Color(0xFF838383),
                          )
                      ),
                    )
                  ]
              ),
              Divider(),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:[
                    Row(
                        children:[
                          Container(
                            width: 75, height: 75,
                            decoration: BoxDecoration(
                              color: Color(0xFF96A7FF),
                              shape: BoxShape.circle,
                            ),
                            child:Padding(
                              padding: const EdgeInsets.only(top:17),
                              child: Text(
                                  "그",
                                  textAlign: TextAlign.center,
                                  style:TextStyle(
                                    color:Colors.white,
                                    fontSize: 25,
                                  )
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left:20),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:[
                                  Text(
                                      "그룹 3",
                                      style:TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 17
                                      )
                                  ),
                                  SizedBox(height:5),
                                  Text(
                                      "진행 중인 정산 : 3 개",
                                      style: TextStyle(
                                        color: Color(0xFFFE5F55),
                                        fontWeight: FontWeight.w500,
                                      )
                                  ),
                                ]
                            ),
                          ),
                        ]
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom:25),
                      child: Text(
                          "2일 전",
                          style:TextStyle(
                            color:Color(0xFF838383),
                          )
                      ),
                    )
                  ]
              ),
              Divider(),
            ]
          ),
        ),
      )
    );
  }
}
