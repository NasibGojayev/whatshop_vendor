/*
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:whatshop_vendor/deletable/add_product.dart';
import 'package:whatshop_vendor/pages/profile.dart';
import '../pages/addAProduct.dart';
import '../pages/home_page.dart';
import 'layout.dart';
final GlobalKey<NavigatorState> _rootNavigatorKey =
GlobalKey<NavigatorState>(debugLabel: 'root');

final GoRouter router = GoRouter(
  initialLocation: '/',
  navigatorKey: _rootNavigatorKey, // Root navigator
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return LayoutScaffold(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: GlobalKey<NavigatorState>(debugLabel: 'home'),
          routes: [
            GoRoute(
              path: '/',
              pageBuilder: (context, state) =>
              const MaterialPage(child: HomePage()),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: GlobalKey<NavigatorState>(debugLabel: 'addProduct'),
          routes: [
            GoRoute(
              path: '/addProduct',
              pageBuilder: (context, state) =>
               MaterialPage(child: AddProduct()),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: GlobalKey<NavigatorState>(debugLabel: 'profile'),
          routes: [
            GoRoute(
              path: '/profile',
              pageBuilder: (context, state) =>
              const MaterialPage(child: Profile()),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: GlobalKey<NavigatorState>(debugLabel: 'profile'),
          routes: [
            GoRoute(
              path: '/profile',
              pageBuilder: (context, state) =>
              const MaterialPage(child: HomePage()),
            ),
          ],
        ),
      ],
    ),
  ],
);
*/
