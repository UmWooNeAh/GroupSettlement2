import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class groupCreatePage extends StatefulWidget {
  const groupCreatePage({Key? key}) : super(key: key);

  @override
  State<groupCreatePage> createState() => _groupCreatePageState();
}

class _groupCreatePageState extends State<groupCreatePage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body:
        GestureDetector(
          onTap:()=>FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left:20),
                  child: Text("새 그룹 생성하기",
                    style:TextStyle(
                      fontSize:20,
                      fontWeight: FontWeight.w800,
                    )
                  ),
                ),
                SizedBox(width:double.infinity,height: 30),
                Padding(
                  padding: const EdgeInsets.only(left:20),
                  child: Text("그룹 이름을 입력해주세요.",
                    style:TextStyle(
                      fontSize:18,
                      fontWeight: FontWeight.w600
                    )
                  ),
                ),
                Align(
                  alignment:Alignment.center,
                  child: SizedBox(
                    width: size.width*0.9,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "그룹 1",
                        labelStyle: TextStyle(
                            color:Color(0xFF838383)
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width:double.infinity, height: 50),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color:Color(0xFFF4F4F4),
                    boxShadow: [
                      BoxShadow(
                        color:Color(0xFFDEDEDE),
                        blurRadius: 1,
                        offset:Offset(1,3)
                      ),
                      BoxShadow(
                          color:Color(0xFFDEDEDE),
                          blurRadius: 1,
                          offset:Offset(1,-3)
                      )
                    ]
                  ),
                  child:
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20,10,20,0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:[
                          Text("그룹원",
                              style:TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600
                              )
                          ),
                          Text.rich(
                              TextSpan(
                                  children: [
                                    TextSpan(
                                        text:"8 ",
                                        style: TextStyle(
                                          color: Color(0xFF07BEB8),
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                        )
                                    ),
                                    TextSpan(
                                        text:"명",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                        )
                                    ),
                                  ]
                              )
                          )
                        ]
                      ),
                    )
                ),
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                      color:Color(0xFFF4F4F4)
                  ),
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height:20),
                            Column(
                              children: List.generate(3,(index){
                                return Row(
                                  children: List.generate(4, (innerIndex){
                                    return um(flag:innerIndex % 2 == 0);
                                  }),
                                );
                              }),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height:10),
                Container(
                  width: double.infinity,
                  height: 80,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left:20),
                        child: Container(
                            width: size.width * 0.42, height: 55,
                            decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(width: 2, color:Color(0xFF07BEB8)),
                                    borderRadius: BorderRadius.circular(5)
                                )
                            ),
                            child:Center(
                                child: Text("Yemon 친구 추가",
                                    style:TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600
                                    )
                                )
                            )
                        ),
                      ),
                      SizedBox(width:size.width*0.05),
                      Padding(
                        padding: const EdgeInsets.only(right:20),
                        child: Container(
                            width: size.width * 0.42, height: 55,
                            decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(width: 2, color:Color(0xFFD9D9D9)),
                                    borderRadius: BorderRadius.circular(5)
                                )
                            ),
                            child:Center(
                                child: Text("직접 인원 추가",
                                    style:TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600
                                    )
                                )
                            )
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(thickness: 10,color:Color(0xFFF4F4F4)),
                Container(
                  width:double.infinity,
                  height:80,
                  child:GestureDetector(
                    child:
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                            width: size.width * 0.9, height: 55,
                            decoration: ShapeDecoration(
                                color: Color(0xFF07BEB8),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)
                                )
                            ),
                            child:Center(
                                child: Text("그룹 생성하기",
                                    style:TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color:Colors.white
                                    )
                                )
                            )
                        ),
                      ),
                  )
                ),
              ],
            ),
          ),
        )
    );
  }
}

class um extends StatelessWidget {
  final bool flag;
  const um({Key? key, required this.flag}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left:35),
      child: Container(
        width: 60,
        height: 120,
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: ShapeDecoration(
                color: Color(0xFF838383),
                shape: OvalBorder(),
              ),
            ),
            SizedBox(height:5),
            Text("이름 1",
                style:TextStyle(
                    fontWeight: FontWeight.w600
                )
            ),

            Text(flag ? "직접 추가함" : "",
                style:TextStyle(
                  fontSize: 12,
                  color: Color(0xFF838383),
                )
            )
          ],
        ),
      ),
    );
  }
}
