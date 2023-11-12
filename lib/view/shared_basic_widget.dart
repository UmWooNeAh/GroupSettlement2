import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:groupsettlement2/viewmodel/MainViewModel.dart';
import 'package:groupsettlement2/viewmodel/UserViewModel.dart';
import 'package:intl/intl.dart';

var priceToString = NumberFormat.currency(locale: 'ko_KR', symbol: "");

class CustomBottomNavigationBar extends ConsumerStatefulWidget {
  const CustomBottomNavigationBar(
      {super.key, required this.index, required this.isIn});
  final int index;
  final bool isIn;

  @override
  ConsumerState<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState
    extends ConsumerState<CustomBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(mainProvider);
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      elevation: 10,
      fixedColor: Colors.black,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      selectedLabelStyle: const TextStyle(
        color: Colors.black,
      ),
      unselectedLabelStyle: const TextStyle(
        color: Colors.black,
      ),
      currentIndex: widget.index,
      onTap: (value) {
        if (!widget.isIn || widget.index != value) {
          switch (value) {
            case 0:
              context.go('/mp');
            case 1:
              context.go('/mp');
            // context.go('/ReceiptBox');
            case 2:
              context.go('/SettlementGroupSelectPage',extra: provider.userData);
            case 3:
              1;
            // context.go('/Notification');
            case 4:
              1;
            // context.go('/Mypage');
          }
        }
      },
      items: [
        BottomNavigationBarItem(
          label: "홈",
          icon: Image.asset('images/bottom_navigation_bar_home.png',
              width: 20, height: 20),
          // icon: SvgPicture.asset(
          //   'images/bottom_navigation_bar_home.svg',
          // ),
        ),
        BottomNavigationBarItem(
          label: "영수증박스",
          icon: Image.asset('images/bottom_navigation_bar_receipt_box.png',
              width: 20, height: 20),
        ),
        BottomNavigationBarItem(
          label: "정산하기",
          icon: Image.asset('images/bottom_navigation_bar_settlement_plus.png',
              width: 20, height: 20),
        ),
        BottomNavigationBarItem(
          label: "알림",
          icon: Image.asset('images/bottom_navigation_bar_notification.png',
              width: 20, height: 20),
        ),
        BottomNavigationBarItem(
          label: "마이페이지",
          icon: Image.asset('images/bottom_navigation_bar_mypage.png',
              width: 20, height: 20),
        ),
      ],
    );
  }
}
