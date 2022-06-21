import 'package:customer_can_do/screens/home_page.dart';
import 'package:customer_can_do/screens/profiel/earning_page.dart';
import 'package:customer_can_do/screens/profiel/profile_page.dart';
import 'package:customer_can_do/screens/profiel/tasklist_page.dart';
import 'package:customer_can_do/screens/search_page.dart';
import 'package:flutter/material.dart';

class TabNavigationItem {
  final Widget page;
  final String title;
  final Icon icon;

  TabNavigationItem({
    required this.page,
    required this.title,
    required this.icon,
  });

  static List<TabNavigationItem> get items => [
        TabNavigationItem(
          page: SearchPage(), //HomePage(),
          icon: Icon(Icons.home),
          title: 'Home',
        ),
        TabNavigationItem(
          page: const TaskListPage(),
          icon: Icon(Icons.history),
          title: 'Orders',
        ),
        TabNavigationItem(
          page: const ProfilePage(),
          icon: Icon(Icons.person),
          title: 'Profile',
        ),
      ];
}
