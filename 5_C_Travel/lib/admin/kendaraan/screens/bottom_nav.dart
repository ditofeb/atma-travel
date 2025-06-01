import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:tubes_5_c_travel/common/constants/colors.dart';
import 'package:tubes_5_c_travel/admin/customer/screens/customer_screen.dart';
import 'package:tubes_5_c_travel/admin/driver/screens/driver_screen.dart';
import 'package:tubes_5_c_travel/admin/jadwal/screens/jadwal_screen.dart';
import 'package:tubes_5_c_travel/admin/kendaraan/screens/kendaraan_screen.dart';

class BottomNavAdmin extends StatefulWidget {
  final Map? data;
  const BottomNavAdmin({super.key, this.data});

  @override
  State<BottomNavAdmin> createState() => _BottomNavAdminState();
}

class _BottomNavAdminState extends State<BottomNavAdmin> {
  @override
  Widget build(BuildContext context) {
    Map? formData = widget.data;

    return BottomNavBar(formData: formData);
  }
}

class BottomNavBar extends StatelessWidget {
  final Map? formData;
  const BottomNavBar({super.key, required this.formData});

  @override
  Widget build(BuildContext context) {
    List<Widget> buildScreens() {
      return [
        CustomerScreen(),
        DriverScreen(),
        KendaraanScreen(),
        JadwalScreen(),
      ];
    }

    List<PersistentBottomNavBarItem> navBarsItems() {
      return [
        PersistentBottomNavBarItem(
          icon: Icon(Icons.people),
          title: ("Customer"),
          activeColorPrimary: themeColor,
          inactiveColorPrimary: Colors.black,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Icons.person_rounded),
          title: ("Driver"),
          activeColorPrimary: themeColor,
          inactiveColorPrimary: Colors.black,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Icons.directions_bus),
          title: ("Kendaraan"),
          activeColorPrimary: themeColor,
          inactiveColorPrimary: Colors.black,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Icons.calendar_today),
          title: ("Jadwal"),
          activeColorPrimary: themeColor,
          inactiveColorPrimary: Colors.black,
        ),
      ];
    }

    PersistentTabController controller;
    controller = PersistentTabController(initialIndex: 0);

    return PersistentTabView(
      context,
      controller: controller,
      screens: buildScreens(),
      items: navBarsItems(),
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardAppears: true,
      popBehaviorOnSelectedNavBarItemPress: PopBehavior.all,
      padding: const EdgeInsets.only(top: 8),
      backgroundColor: Colors.white,
      isVisible: true,
      confineToSafeArea: true,
      navBarHeight: kBottomNavigationBarHeight,
      decoration: NavBarDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      navBarStyle: NavBarStyle.style3,
    );
  }
}
