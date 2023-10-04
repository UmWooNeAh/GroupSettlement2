import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class notificationPage extends StatefulWidget {
  const notificationPage({Key? key}) : super(key: key);

  @override
  State<notificationPage> createState() => _notificationPageState();
}

class _notificationPageState extends State<notificationPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body:
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left:30),
              child: Text("알림",
                style:TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                )
              ),
            ),
            SizedBox(width:double.infinity,height:50),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left:30),
                  child: Row(
                    children: [
                      Container(
                        width: size.width*0.03,
                        height: size.width*0.03,
                        decoration: BoxDecoration(
                          color: Color(0xFFFE5F55),
                          shape: BoxShape.circle
                        ),
                      ),
                      SizedBox(width:size.width * 0.04),
                      Text(
                        "받을 정산 알림",
                        style:TextStyle(
                          fontSize:20,
                          fontWeight: FontWeight.w500
                        )
                      ),
                      SizedBox(width: size.width*0.4),
                      Container(
                        width: size.width*0.08,
                        height: size.width*0.05,
                        decoration: BoxDecoration(
                          color: Color(0xFFFE5F55),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child:Center(
                          child:Text(
                            "+5",
                            style:TextStyle(
                              color: Colors.white,
                            )
                          )
                        )
                      )
                    ],
                  ),
                ),
                SizedBox(height:10),
                Container(
                  width: size.width * 0.9,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Color(0xFFFE5F55),
                  ),
                  child:Padding(
                    padding: const EdgeInsets.only(top:13,left:15),
                    child: Text(
                      "'박건우'님이 '어제 술값' 정산 송금을 했어요.",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 16
                      ),
                    ),
                  )
                ),
              ],
            ),
            SizedBox(width:double.infinity,height:50),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left:30),
                  child: Row(
                    children: [
                      Container(
                        width: size.width*0.03,
                        height: size.width*0.03,
                        decoration: BoxDecoration(
                            color: Color(0xFF07BEB8),
                            shape: BoxShape.circle
                        ),
                      ),
                      SizedBox(width:size.width * 0.04),
                      Text(
                          "보낼 정산 알림",
                          style:TextStyle(
                              fontSize:20,
                              fontWeight: FontWeight.w500
                          )
                      ),
                      SizedBox(width: size.width*0.4),
                      Container(
                          width: size.width*0.08,
                          height: size.width*0.05,
                          decoration: BoxDecoration(
                            color: Color(0xFF07BEB8),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child:Center(
                              child:Text(
                                  "+3",
                                  style:TextStyle(
                                    color: Colors.white,
                                  )
                              )
                          )
                      )
                    ],
                  ),
                ),
                SizedBox(height:10),
                Container(
                    width: size.width * 0.9,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Color(0xFF07BEB8),
                    ),
                    child:Padding(
                      padding: const EdgeInsets.only(top:13,left:15),
                      child: Text(
                        "'엄우네아' 정산 송금을 해주세요!",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 16
                        ),
                      ),
                    )
                ),
              ],
            ),
            SizedBox(width:double.infinity,height:50),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left:30),
                  child: Row(
                    children: [
                      Container(
                        width: size.width*0.03,
                        height: size.width*0.03,
                        decoration: BoxDecoration(
                            color: Color(0xFF565659),
                            shape: BoxShape.circle
                        ),
                      ),
                      SizedBox(width:size.width * 0.04),
                      Text(
                          "기타 알림",
                          style:TextStyle(
                              fontSize:20,
                              fontWeight: FontWeight.w500
                          )
                      ),
                      SizedBox(width: size.width*0.5),
                      Container(
                          width: size.width*0.08,
                          height: size.width*0.05,
                          decoration: BoxDecoration(
                            color: Color(0xFF565659),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child:Center(
                              child:Text(
                                  "+3",
                                  style:TextStyle(
                                    color: Colors.white,
                                  )
                              )
                          )
                      )
                    ],
                  ),
                ),
                SizedBox(height:10),
                Container(
                    width: size.width * 0.9,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Color(0xFF565659),
                    ),
                    child:Padding(
                      padding: const EdgeInsets.only(top:13,left:15),
                      child: Text(
                        "새로운 정산 '점심 찜닭'이 생성되었어요.",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 16
                        ),
                      ),
                    )
                ),
              ],
            )
          ],
        )
    );
  }
}
