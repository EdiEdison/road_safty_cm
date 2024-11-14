import 'package:flutter/material.dart';
import 'package:road_safty_cm/app_colors.dart';
import 'package:road_safty_cm/screens/map_screens/map_screen.dart';
import 'package:road_safty_cm/screens/notification_screens/notification_screen.dart';
import 'package:road_safty_cm/screens/setting_screens/setting_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static const List<Widget> _pages = <Widget>[
    MapScreen(),
    NotificationScreen(),
    SettingScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: RColors.buttonColor,
          unselectedItemColor: RColors.textPrimary,
          backgroundColor: RColors.primaryBackground,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notifications'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Setting'),
          ],
        ),
        body: Center(
          child: _pages.elementAt(_selectedIndex), //New
        ),
    );
  }
}
