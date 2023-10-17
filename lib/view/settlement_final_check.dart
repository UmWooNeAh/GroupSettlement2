import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groupsettlement2/design_element.dart';
import 'package:groupsettlement2/view/shared_basic_widget.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import '../viewmodel/SettlementViewModel.dart';

class SettlementFinalCheckPage extends ConsumerStatefulWidget {
  const SettlementFinalCheckPage({super.key});

  @override
  ConsumerState<SettlementFinalCheckPage> createState() =>
      _SettlementFinalCheckPage();
}

class _SettlementFinalCheckPage
    extends ConsumerState<SettlementFinalCheckPage> {
  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(stmProvider.notifier);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Container(
            width: size.width,
            margin: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              provider.settlement.settlementName ?? "Name",
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 10,
            ),
            width: size.width,
            child: const Text(
              "정산 결과 확인",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children:
                  List.generate(provider.settlementPapers.keys.length, (index) {
                String id = provider.settlementPapers.keys.toList()[index];
                return SettlementFinalCheckUserPanel(index: id);
              }),
            ),
          )),
          const Divider(
            thickness: 5,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "합계 금액",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  "${priceToString.format(provider.receipts.values.toList().map((receipt) => receipt.totalPrice).reduce((value, element) => value + element))}원",
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: color2,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: size.width,
            height: 50,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(
                  color: color2,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                "전체 정산서 확인하기",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
          Container(
            height: 80,
            width: size.width,
            color: Colors.grey[100],
            child: Align(
              alignment: const Alignment(0, 0),
              child: Container(
                width: size.width,
                height: 50,
                margin: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 20.0),
                child: OutlinedButton(
                  onPressed: () async{
                    await UserApi.instance.loginWithNewScopes(["friends","talk_message"]);

                    try {
                      List<ItemInfo> itemList = [];
                      provider.settlementPapers.values.forEach((element) {
                        itemList.add(ItemInfo(item:element.userName!, itemOp: element.totalPrice.toString()));
                      });
                      Uri shareUrl = await WebSharerClient.instance.makeDefaultUrl(template:
                        FeedTemplate(
                          content: Content(
                            title: '${provider.settlementUsers[0].name}님이 정산 요청을 보냈어요.\n내역을 확인한 후 송금해주세요',
                            description: provider.settlementUsers[0].accountInfo.first,
                            imageUrl: Uri.parse(
                                'https://www.press9.kr/news/photo/201910/30004_craw1.jpg'),
                            link: Link(
                                webUrl: Uri.parse('https://fir-df691.web.app/#/'),
                                mobileWebUrl: Uri.parse('https://fir-df691.web.app/#/')),
                          ),
                          itemContent: ItemContent(
                            profileText: "Yemon",
                            profileImageUrl: Uri.parse(
                                'https://engineering.linecorp.com/wp-content/uploads/2019/08/flutter1.png'),
                            titleImageUrl: Uri.parse(
                                'https://engineering.linecorp.com/wp-content/uploads/2019/08/flutter1.png'),
                            titleImageText: provider.settlement.settlementName,
                            titleImageCategory: provider.receipts.values.first.receiptName,
                            items: itemList,
                            sum: 'total',
                            sumOp: priceToString.format(provider.settlement.totalPrice),
                          ),
                          buttons: [
                            Button(
                              title: '정산서 보기',
                              link: Link(
                                webUrl: Uri.parse('https://fir-df691.web.app/#/'),
                                mobileWebUrl: Uri.parse('https://fir-df691.web.app/#/'),
                              ),
                            ),
                            Button(
                              title: '앱으로보기',
                              link: Link(
                                androidExecutionParams: {'key1': 'value1', 'key2': 'value2'},
                                iosExecutionParams: {'key1': 'value1', 'key2': 'value2'},
                              ),
                            ),
                          ],
                        )
                      );
                      await launchBrowserTab(shareUrl, popupOpen: true);
                    } catch (error) {
                      print('카카오톡 공유 실패 $error');
                    }
                    print('친구 선택 성공');
                    setState(() {});
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(
                      color: Colors.grey,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    "카카오톡으로 정산서 공유하기",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SettlementFinalCheckUserPanel extends ConsumerStatefulWidget {
  const SettlementFinalCheckUserPanel({super.key, required this.index});
  final String index;

  @override
  ConsumerState<SettlementFinalCheckUserPanel> createState() =>
      _SettlementFinalCheckUserPanelState();
}

class _SettlementFinalCheckUserPanelState
    extends ConsumerState<SettlementFinalCheckUserPanel> {
  bool selected = false;
  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(stmProvider.notifier);
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              selected = !selected;
            });
          },
          child: Container(
            padding: const EdgeInsets.all(10.0),
            height: 80,
            width: size.width,
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 150,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ClipOval(
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          width: 60,
                          height: 60,
                          color: colorGrey,
                        ),
                      ),
                      Text(
                        "${(provider.settlementPapers[widget.index]?.userName ?? "그룹원")}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    "${priceToString.format(provider.settlementPapers[widget.index]?.totalPrice)}원",
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        const Divider(
          endIndent: 10,
          indent: 10,
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: size.width,
          height: selected ? 70 : 0,
          color: Colors.grey[200],
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(
                    color: Colors.grey,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
              onPressed: () {},
              child: Stack(
                children: [
                  Visibility(
                    visible: selected ? true : false,
                    child: const Align(
                      alignment: Alignment(1, 0.0),
                      child: Icon(Icons.arrow_forward_ios_sharp),
                    ),
                  ),
                  const Align(
                    alignment: Alignment(0, 0),
                    child: Text(
                      "정산서 확인",
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
