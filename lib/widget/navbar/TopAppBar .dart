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

  const TopAppBar({super.key, this.height = kToolbarHeight});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
        title: Container(
          margin: const EdgeInsets.only(left: 16.0),
          child: Image.asset(
            'assets/logo/logo_without_name.png',
            height: 32,
          ),
        ),
        actions: [
          _buildActionIcon(
            icon: Icons.search,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserSearchPage()),
              );
            },
          ),
          _buildActionIcon(
            icon: Icons.messenger_outline,
            onPressed: () {
              // BottomNavBar.visibility(false);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatListScreen()),
              ).then((_) {
                // BottomNavBar.visibility(true);
              });
            },
          ),
          _buildActionIcon(
            icon: Icons.notifications,
            onPressed: () {
              // BottomNavBar.visibility(false);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationScreen()),
              ).then((_) {
                // BottomNavBar.visibility(true);
              });
            },
          ),
        ],
      ),
    );
  }

  // Helper function to build the circular icon with margin
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
