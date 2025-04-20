import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'colors.dart';

class NavigationMenu extends StatelessWidget {
  final Widget child; // <-- This is the page rendered
  const NavigationMenu({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouter.of(context).state.matchedLocation;

    return Scaffold(

      bottomNavigationBar: NavigationBar(
        height: 80,
        elevation: 0,
        selectedIndex: _calculateSelectedIndex(location),
        onDestinationSelected: (index) {
          switch (index) {
            case 0:

              if(!location.startsWith('/home')){
                context.push('/home');
              }
              break;
            case 1:

              if(!location.startsWith('/all_products')){
                context.push('/all_products');
              }
              break;

            case 2:

              if(!location.startsWith('/profile')){
                context.push('/profile');
              }
              break;
          }
        },
        destinations: [
          NavigationDestination(icon: const Icon(Icons.home_outlined), label: 'Ana səhifə',selectedIcon: Icon(Icons.home,color: mainBlue,),),
          NavigationDestination(icon: const Icon(Icons.list_alt_outlined), label: 'Məhsullarım',selectedIcon: Icon(Icons.list_alt,color: mainBlue,),),
          NavigationDestination(icon: const Icon(Icons.manage_accounts_outlined), label: 'Profil',selectedIcon: Icon(Icons.manage_accounts,color: mainBlue,),),
        ],
      ),
      body: child,
    );
  }

  int _calculateSelectedIndex(String location) {
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/all_products')) return 1;
    if (location.startsWith('/profile')) return 2;


    return 0;
  }
}
