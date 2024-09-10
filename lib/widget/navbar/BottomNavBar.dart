import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ocean_rescue/pages/event/event_screen.dart';
import 'package:ocean_rescue/pages/menu/menu_screen.dart';
import 'package:ocean_rescue/pages/notification/notification_screen.dart';
import 'package:ocean_rescue/pages/qr/qr_scanner_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import '../../pages/feed/feed_screen.dart';
import '../../theme/colorTheme.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    // Define the screens for each tab
    List<Widget> _buildScreens() {
      return [
        FeedScreen(),
        EventScreen(),
        QrScanner(),
        NotificationScreen(),
        MenuScreen(),
      ];
    }

    // Define the bottom nav bar items
    List<PersistentBottomNavBarItem> _navBarsItems() {
      return [
        PersistentBottomNavBarItem(
          icon: Icon(Icons.home_rounded),
          title: ("Home"),
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Icons.calendar_month),
          title: ("Event"),
        ),
        PersistentBottomNavBarItem(
          icon: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ColorTheme.darkBlue2,
            ),
            padding: EdgeInsets.all(10),
            child: Icon(Icons.qr_code_scanner_outlined),
          ),
          title: ("QR Scanner"),
          activeColorPrimary: Colors.white,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Icons.notifications),
          title: ("Qracanner"),
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Icons.menu),
          title: ("Qracanner"),
        ),
      ];
    }

    // Define the tab controller
    PersistentTabController _controller =
        PersistentTabController(initialIndex: 0);

    // Define the nav bar style
    final _navBarStyle = NavBarStyle.style1; // Choose from style1, style2, etc.

    // Return the PersistentTabView widget
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      handleAndroidBackButtonPress: true, // Default is true.
      resizeToAvoidBottomInset: true, // Default is true.
      stateManagement: true, // Default is true.
      hideNavigationBarWhenKeyboardAppears: true,
      // popBehaviorOnSelectedNavBarItemPress:
      //     PopActionScreensType.all, // Fix for PopActionScreensType
      padding: const EdgeInsets.only(top: 8),
      backgroundColor: Colors.white,
      isVisible: true,
      animationSettings: const NavBarAnimationSettings(
        navBarItemAnimation: ItemAnimationSettings(
          // Navigation Bar's items animation properties.
          duration: Duration(milliseconds: 400),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimationSettings(
          // Screen transition animation.
          animateTabTransition: true,
          duration: Duration(milliseconds: 200),
          screenTransitionAnimationType: ScreenTransitionAnimationType.fadeIn,
        ),
      ),
      confineToSafeArea: true,
      navBarHeight: kBottomNavigationBarHeight,
      navBarStyle: NavBarStyle.style13, // Use the defined nav bar style
    );
  }
}
