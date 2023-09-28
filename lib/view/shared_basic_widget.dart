import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class BottomNavigationBarIndex extends StateNotifier<int> {
  BottomNavigationBarIndex() : super(0);

  void changeIndex(value) {
    state = value;
  }
}

final bottomIndexProvider =
    StateNotifierProvider((ref) => BottomNavigationBarIndex());

class CustomBottomNavigationBar extends ConsumerStatefulWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  ConsumerState<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState
    extends ConsumerState<CustomBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
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
      currentIndex: ref.watch(bottomIndexProvider) as int,
      onTap: (value) {
        if (ref.watch(bottomIndexProvider) != value) {
          switch (value) {
            case 0:
              context.go('/');
              ref.watch(bottomIndexProvider.notifier).changeIndex(value);
            case 1:
              1;
              ref.watch(bottomIndexProvider.notifier).changeIndex(value);
            // context.go('/ReceiptBox');
            case 2:
              context.go('/CreateNewSettlementPage');
              ref.watch(bottomIndexProvider.notifier).changeIndex(value);
            case 3:
              1;
              // context.go('/Notification');
              ref.watch(bottomIndexProvider.notifier).changeIndex(value);
            case 4:
              1;
              // context.go('/Mypage');
              ref.watch(bottomIndexProvider.notifier).changeIndex(value);
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
