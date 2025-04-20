/*
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/src/route.dart';
import 'package:whatshop_vendor/tools/colors.dart';

import 'models/destination.dart';

class LayoutScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const LayoutScaffold({
    super.key,
    required this.navigationShell});
  @override
  Widget build(BuildContext context) {
    return PopScope(

      child: Scaffold(
        body: navigationShell,
        bottomNavigationBar: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: navigationShell.goBranch,
        indicatorColor: mainBlue

        , destinations: destinations.map((destination)=>NavigationDestination(
          icon: destination.icon,
          label: destination.label,
        )).toList(),
        ),
      ),
    );
  }
}
*/
