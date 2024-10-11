import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ocean_rescue/pages/chat/chat_list_screen.dart';
import 'package:ocean_rescue/pages/notification/notification_screen.dart';
import 'package:ocean_rescue/pages/search/search_screen.dart';
import 'package:ocean_rescue/utils/colors.dart';
import 'package:ocean_rescue/widget/navbar/BottomNavBar.dart';
import '../../theme/colorTheme.dart';

class TopAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final ValueNotifier<int> selectedTabIndex;

  const TopAppBar(
      {super.key,
      this.height = kToolbarHeight,
      required this.selectedTabIndex});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: selectedTabIndex,
      builder: (context, currentIndex, child) {
        return AppBar(
          backgroundColor: Colors.white,
          centerTitle: false,
          title: Container(
            margin: const EdgeInsets.only(left: 16.0),
            child: Image.asset(
              'assets/logo/logo_without_name.png',
              height: 32,
            ),
          ),
          actions: _getActionsForTab(
              context, currentIndex), // Show icons based on selected tab
        );
      },
    );
  }

  List<Widget> _getActionsForTab(BuildContext context, int currentIndex) {
    switch (currentIndex) {
      case 0: // Home Screen
        return [
          _buildActionIcon(
              icon: Icons.search,
              onPressed: () {
                // BottomNavBar.visibility(false);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserSearchPage()),
                ).then((_) {
                  // BottomNavBar.visibility(true);
                });
              }),
          ..._defaultIcions(context),
          _buildActionIcon(
              icon: Icons.notifications,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NotificationScreen()),
                );
              }),
        ];
      case 1: // Report Screen
        return [
          ..._defaultIcions(context),
        ];
      case 2: // QR Scanner Screen
        return [];
      case 3: // Event Screen
        return [
          ..._defaultIcions(context),
        ];
      case 4: // Menu Screen
        return [];
      default:
        return [];
    }
  }

  List<Widget> _defaultIcions(BuildContext context) {
    // Return a default widget or throw an exception
    return [
      _buildActionIcon(
          icon: Icons.messenger_outline,
          onPressed: () {
            BottomNavBar.visibility(false);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChatListScreen()),
            ).then((_) {
              BottomNavBar.visibility(true);
            });
          }),
    ]; // Example: returning an empty container
  }

  Widget _buildActionIcon(
      {required IconData icon, required VoidCallback onPressed}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: CircleAvatar(
        radius: 20,
        backgroundColor: ColorTheme.liteBlue2,
        child: IconButton(
          icon: Icon(icon, color: ColorTheme.lightBlue1),
          onPressed: onPressed,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
