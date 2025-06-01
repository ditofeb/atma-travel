import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:tubes_5_c_travel/admin/jadwal/screens/jadwal_screen.dart';
import 'package:tubes_5_c_travel/common/constants/colors.dart';
import 'package:tubes_5_c_travel/home/screens/add_trip_screen.dart';
import 'package:tubes_5_c_travel/home/screens/profile_screen.dart';
import 'package:tubes_5_c_travel/home/screens/home_screen.dart';
import 'package:tubes_5_c_travel/history/screens/history_screen.dart';

class BottomNavHomeScreen extends StatefulWidget {
  const BottomNavHomeScreen({super.key});

  @override
  State<BottomNavHomeScreen> createState() => _BottomNavHomeScreenState();
}

class _BottomNavHomeScreenState extends State<BottomNavHomeScreen> {
  late PersistentTabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavBar();
  }
}

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> buildScreens() {
      return [
        HomeScreen(),
        AddTripScreen(),
        HistoryScreen(),
        ProfileScreen(),
      ];
    }

    List<PersistentBottomNavBarItem> navBarsItems() {
      return [
        PersistentBottomNavBarItem(
          icon: Icon(Icons.home_rounded),
          title: ("Home"),
          activeColorPrimary: themeColor,
          inactiveColorPrimary: Colors.black,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Icons.add_location_rounded),
          title: ("Add Trip"),
          activeColorPrimary: themeColor,
          inactiveColorPrimary: Colors.black,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Icons.history_rounded),
          title: ("History"),
          activeColorPrimary: themeColor,
          inactiveColorPrimary: Colors.black,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Icons.person_rounded),
          title: ("Profile"),
          activeColorPrimary: themeColor,
          inactiveColorPrimary: Colors.black,
        ),
      ];
    }

    PersistentTabController controller;
    controller = PersistentTabController(initialIndex: 0);

    return Consumer(builder: (context, ref, child) {
      controller.addListener(() {
        if (controller.index < 3) {
          ref.refresh(listPemesananProvider);
          ref.refresh(listJadwalProvider);
        } else if (controller.index == 3) {
          ref.refresh(userProvider);
        }
      });

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
    });
  }
}
