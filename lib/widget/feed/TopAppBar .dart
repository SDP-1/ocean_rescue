import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ocean_rescue/utils/colors.dart';

import '../../theme/colorTheme.dart';

class TopAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;

  TopAppBar({Key? key, this.height = kToolbarHeight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ColorTheme.white,
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
            // Add your search logic here
          },
        ),
        _buildActionIcon(
          icon: Icons.messenger_outline,
          onPressed: () {
            // Add your messenger logic here
          },
        ),
      ],
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
          icon: Icon(icon, color: ColorTheme.liteBlue1),
          onPressed: onPressed,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
