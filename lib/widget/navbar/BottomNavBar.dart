import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ocean_rescue/pages/dumpReport/dump_dashboard_screen.dart';
import 'package:ocean_rescue/pages/event/create_event_screen1.dart';
import 'package:ocean_rescue/pages/event/event_screen.dart';
import 'package:ocean_rescue/pages/menu/menu_screen.dart';
import 'package:ocean_rescue/pages/notification/notification_screen.dart';
import 'package:ocean_rescue/pages/profile/edit_profile.dart';
import 'package:ocean_rescue/pages/qr/qr_scanner.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import '../../pages/feed/feed_screen.dart';
import '../../theme/colorTheme.dart';

class BottomNavBar extends StatelessWidget {
  static final ValueNotifier<bool> isNavBarVisible = ValueNotifier(true);
  static final ValueNotifier<int> selectedTabIndex =
      ValueNotifier(0); // To track selected tab index

  const BottomNavBar({super.key});

  // Static method to show the navigation bar
  static void visibility(bool visibility) {
    isNavBarVisible.value = visibility;
  }

  // Static method to hide the navigation bar
  static void hideNavBar() {
    isNavBarVisible.value = false;
  }

  @override
  Widget build(BuildContext context) {
    PersistentTabController controller =
        PersistentTabController(initialIndex: 0);

    return ValueListenableBuilder<bool>(
      valueListenable: isNavBarVisible,
      builder: (context, isVisible, child) {
        return PersistentTabView(
          context,
          controller: controller,
          screens: _buildScreens(),
          items: _navBarsItems(),
          onItemSelected: (index) {
            selectedTabIndex.value = index; // Update the selected tab index
          },
          handleAndroidBackButtonPress: true,
          resizeToAvoidBottomInset: false,
          stateManagement: true,
          hideNavigationBarWhenKeyboardAppears: false,
          padding: const EdgeInsets.only(top: 5),
          backgroundColor: Colors.white,
          isVisible: isVisible,
          navBarStyle: NavBarStyle.style13,
        );
      },
    );
  }

  List<Widget> _buildScreens() {
    return [
      const FeedScreen(),
      DumpsDashboard(),
      QRScanner(),
      EventScreen(),
      const EditProfile(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home_outlined),
        title: ("Home"),
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.report_gmailerrorred_rounded),
        title: ("Report"),
      ),
      PersistentBottomNavBarItem(
        icon: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: ColorTheme.darkBlue2,
          ),
          padding: const EdgeInsets.all(10),
          child: const Icon(Icons.qr_code_scanner_outlined),
        ),
        title: ("QR Scanner"),
        activeColorPrimary: Colors.white,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.event_outlined),
        title: ("Event"),
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.menu),
        title: ("Menu"),
      ),
    ];
  }
}
