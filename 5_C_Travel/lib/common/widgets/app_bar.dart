import 'package:flutter/material.dart';
import 'package:tubes_5_c_travel/common/constants/colors.dart';
import 'package:tubes_5_c_travel/common/constants/fonts.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showLeadingIcon;
  final bool showLogoutIcon;
  final bool showCheckIcon;
  final VoidCallback? onLeadingIconPressed;
  final VoidCallback? onLogoutIconPressed;
  final VoidCallback? onCheckIconPressed;
  final bool centerTitle;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showLeadingIcon = false,
    this.showLogoutIcon = false,
    this.showCheckIcon = false,
    this.onLeadingIconPressed,
    this.onLogoutIconPressed,
    this.onCheckIconPressed,
    this.centerTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 75.0,
      title: Text(
        title,
        style: TextStyles.poppinsBold(fontSize: 20, color: Colors.white),
      ),
      centerTitle: centerTitle,
      leading: showLeadingIcon
          ? IconButton(
              icon: Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.white,
              ),
              onPressed: onLeadingIconPressed,
            )
          : null,
      actions: [
        if (showLogoutIcon)
          IconButton(
            onPressed: onLogoutIconPressed,
            icon: Icon(
              Icons.logout_rounded,
              color: Colors.white,
            ),
          ),
        if (showCheckIcon)
          IconButton(
            onPressed: onCheckIconPressed,
            icon: Icon(
              Icons.check,
              color: Colors.white,
            ),
          ),
      ],
      elevation: 0,
      backgroundColor: themeColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(10),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(75.0);
}
