import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../class/class_user.dart';
import '../design_element.dart';
import '../viewmodel/GroupCreateViewModel.dart';

class GroupCreatePage extends ConsumerStatefulWidget {
  const GroupCreatePage({Key? key, required this.me}) : super(key: key);
  final ServiceUser me;

  @override
  ConsumerState<GroupCreatePage> createState() => _GroupCreatePageState();
}

class _GroupCreatePageState extends ConsumerState<GroupCreatePage> {
  bool isFirst = true;
  String inputGroupName = "";
  String inputName = "";
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final provider = ref.watch(groupCreateProvider);
    if(isFirst){
      Future((){
        provider.settingGroupCreateViewModel(widget.me); 
      });
      isFirst = false;
    }
    return Scaffold(
        appBar: AppBar(),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 20, bottom: 20),
                  child: Text(
                    "새 그룹 생성하기",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    "그룹 이름을 입력해주세요.",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20, bottom: 50),
                  width: size.width * 0.9,
                  child: TextField(
                    onChanged: (value) {
                      inputGroupName = value;
                    },
                    decoration: const InputDecoration(
                      hintText: "그룹 1",
                      labelStyle: TextStyle(color: Color(0xFF838383)),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF4F4F4),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFFDEDEDE),
                        blurRadius: 1,
                        offset: Offset(1, 3),
                      ),
                      BoxShadow(
                        color: Color(0xFFDEDEDE),
                        blurRadius: 1,
                        offset: Offset(1, -3),
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "그룹원",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "${provider.serviceUsers.length.toString()} ",
                              style: const TextStyle(
                                color: Color(0xFF07BEB8),
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const TextSpan(
                              text: "명",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: const BoxDecoration(color: Color(0xFFF4F4F4)),
                  child: SingleChildScrollView(
                    child: Column(
                      children: List.generate(
                          ((provider.serviceUsers.length - 1) ~/ 4) + 1, (index) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: List.generate(4, (innerIndex) {
                            try {
                              ServiceUser user =
                                  provider.serviceUsers[index * 4 + innerIndex];
                              bool flag = user.kakaoId == null ? true : false;
                              //카카오 아이디 존재시 false -> 직접 추가됨
                              bool userFlag = user.serviceUserId ==
                                      provider.userData.serviceUserId
                                  ? true
                                  : false;
                              //사용자 본인일시 삭제버튼 무효화
                              return Stack(
                                children: [
                                  const SizedBox(
                                    width: 90,
                                    height: 120,
                                  ),
                                  Positioned(
                                    left: 15,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 60,
                                          height: 60,
                                          decoration: const ShapeDecoration(
                                            color: Color(0xFF838383),
                                            shape: OvalBorder(),
                                          ),
                                        ),
                                        Container(
                                          width: 60,
                                          margin: const EdgeInsets.only(top: 5),
                                          child: Text(
                                            user.name!,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(top: 5),
                                          child: Text(
                                            flag
                                                ? "직접 추가함"
                                                : (userFlag ? "나" : ""),
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: userFlag
                                                  ? color1
                                                  : const Color(0xFF838383),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    right: 5,
                                    child: userFlag == false
                                        ? GestureDetector(
                                            onTap: () {
                                              provider.removeGroupUser(user);
                                            },
                                            child: const Icon(Icons.close))
                                        : const SizedBox.shrink(),
                                  )
                                ],
                              );
                            } on RangeError catch (e) {
                              print(e);
                              return const SizedBox(
                                width: 90,
                                height: 120,
                              );
                            }
                          }),
                        );
                      }),
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 60,
                        margin: const EdgeInsets.only(left: 20),
                        width: (size.width - 60) / 2,
                        child: OutlinedButton(
                          onPressed: () async {},
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              width: 2,
                              color: Color(0xFF07BEB8),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            "Yemon 친구 추가",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 60,
                        margin: const EdgeInsets.only(right: 20),
                        width: (size.width - 60) / 2,
                        child: OutlinedButton(
                          onPressed: () => showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text("추가할 사용자의 이름을 입력해주세요",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18)),
                              content: TextField(
                                decoration: const InputDecoration(
                                  hintText: "사용자 1",
                                  labelStyle:
                                      TextStyle(color: Color(0xFF838383)),
                                ),
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
                                      Navigator.of(context).pop();
                                      setState(
                                        () {
                                          if (inputName != "") {
                                            provider.addByDirect(inputName);
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content:
                                                    Text('사용자명은 공백이 될 수 없습니다'),
                                                duration: Duration(seconds: 3),
                                              ),
                                            );
                                          }
                                        },
                                      );
                                      inputName = "";
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
                                      "인원 추가",
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.white),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 50,
                                  child: OutlinedButton(
                                    onPressed: () {
                                      context.pop();
                                      inputName = "";
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
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              width: 2,
                              color: Color(0xFFC9C9C9),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            "직접 인원 추가",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(thickness: 5, color: Color(0xFFF4F4F4)),
                SizedBox(
                  width: double.infinity,
                  height: 80,
                  child: GestureDetector(
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: size.width * 0.9,
                        height: 55,
                        decoration: ShapeDecoration(
                          color: const Color(0xFF07BEB8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            if (inputGroupName == "") {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('그룹명은 공백이 될 수 없습니다'),
                                  duration: Duration(seconds: 3),
                                ),
                              );
                            } else {
                              provider.createGroup(inputGroupName);
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext ctx) {
                                  return AlertDialog(
                                    content: const Text("성공적으로 그룹이 생성되었습니다."),
                                    actions: [
                                      Center(
                                        child: ElevatedButton(
                                          child: const Text("확인"),
                                          onPressed: () {
                                            context.pop();
                                            context.pushReplacement("/SettlementGroupSelect", extra:provider.userData);
                                          },
                                        ),
                                      )
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          child: const Center(
                            child: Text(
                              "그룹 생성하기",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

// class GroupUser extends StatefulWidget {
//   final bool flag;
//   final ServiceUser user;
//   final GroupCreateViewModel gvm;
//   const GroupUser(
//       {Key? key, required this.flag, required this.user, required this.gvm})
//       : super(key: key);

//   @override
//   State<GroupUser> createState() => _GroupUserState();
// }

// class _GroupUserState extends State<GroupUser> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.pink,
//       padding: const EdgeInsets.all(10),
//       child: Stack(
//         children: [
//           Container(
//             width: 60,
//             height: 122,
//             child: Column(
//               children: [
//                 Container(
//                   width: 60,
//                   height: 60,
//                   decoration: ShapeDecoration(
//                     color: Color(0xFF838383),
//                     shape: OvalBorder(),
//                   ),
//                 ),
//                 SizedBox(height: 5),
//                 Text(widget.user.name!,
//                     style:
//                         TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
//                 Text(widget.flag ? "직접 추가함" : "",
//                     style: TextStyle(
//                       fontSize: 10,
//                       color: Color(0xFF838383),
//                     ))
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(bottom: 20, left: 45),
//             child: GestureDetector(
//                 onTap: () {
//                   widget.gvm.serviceUsers.removeWhere(
//                       (element) => element.name == widget.user.name);
//                 },
//                 child: Text("X",
//                     style:
//                         TextStyle(fontSize: 23, fontWeight: FontWeight.w600))),
//           )
//         ],
//       ),
//     );
//   }
// }
