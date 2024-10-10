import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ocean_rescue/pages/dumpReport/dump_dashboard_screen.dart';
import 'package:ocean_rescue/pages/event/create_event_screen1.dart';
import 'package:ocean_rescue/pages/event/event_screen.dart';
import 'package:ocean_rescue/pages/menu/menu_screen.dart';
import 'package:ocean_rescue/pages/notification/notification_screen.dart';
import 'package:ocean_rescue/pages/profile/edit_profile.dart';
import 'package:ocean_rescue/pages/qr/qr_scanner_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import '../../pages/feed/feed_screen.dart';
import '../../theme/colorTheme.dart';

class BottomNavBar extends StatelessWidget {
  static final ValueNotifier<bool> isNavBarVisible = ValueNotifier(true);

  const BottomNavBar({super.key});

  // Static method to show the navigation bar
  static void visibility(bool visiblity) {
    isNavBarVisible.value = visiblity;
  }

  // Static method to hide the navigation bar
  static void hideNavBar() {
    isNavBarVisible.value = false;
  }

  @override
  Widget build(BuildContext context) {
    // Define the screens for each tab
    List<Widget> buildScreens() {
      return [
        const FeedScreen(),
        DumpsDashboard(),
        const QrScanner(),
        EventScreen(),
        const EditProfile(),
      ];
    }

    // Define the bottom nav bar items
    List<PersistentBottomNavBarItem> navBarsItems() {
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

    // Define the tab controller
    PersistentTabController controller =
        PersistentTabController(initialIndex: 0);

    // Return the PersistentTabView widget
    return ValueListenableBuilder<bool>(
      valueListenable: isNavBarVisible,
      builder: (context, isVisible, child) {
        return PersistentTabView(
          context,
          controller: controller,
          screens: buildScreens(),
          items: navBarsItems(),
          handleAndroidBackButtonPress: true, // Default is true.
          resizeToAvoidBottomInset:
              false, // Set to false to prevent nav bar from moving.
          stateManagement: true, // Default is true.
          hideNavigationBarWhenKeyboardAppears:
              false, // Optional: Keep the nav bar visible.
          padding: const EdgeInsets.only(top: 5),
          backgroundColor: Colors.white,
          isVisible:
              isVisible, // Use the static ValueNotifier to control visibility
          animationSettings: const NavBarAnimationSettings(
            navBarItemAnimation: ItemAnimationSettings(
              // Navigation Bar's items animation properties.
              duration: Duration(milliseconds: 10),
              curve: Curves.ease,
            ),
            screenTransitionAnimation: ScreenTransitionAnimationSettings(
              // Screen transition animation.
              animateTabTransition: true,
              duration: Duration(milliseconds: 5),
              screenTransitionAnimationType:
                  ScreenTransitionAnimationType.fadeIn,
            ),
          ),
          confineToSafeArea: true,
          navBarHeight: kBottomNavigationBarHeight,
          navBarStyle: NavBarStyle.style13, // Use the defined nav bar style
        );
      },
    );
  }
}
