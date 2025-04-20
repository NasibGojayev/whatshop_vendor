import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:whatshop_vendor/auth/auth_gate.dart';
import 'package:whatshop_vendor/auth/sign_in.dart';
import 'package:whatshop_vendor/pages/my_products_page.dart';
import 'package:whatshop_vendor/pages/add_product_flow.dart';
import '../auth/sign_up.dart';
import '../bloc_management/product_bloc/product_bloc.dart';
import '../pages/dashboard.dart';
import '../pages/edit_product_page.dart';
import '../pages/product_view.dart';
import '../pages/profile.dart';
import '../pages/vendorDetailsPage.dart';
import 'navigation_menu.dart';


final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => const MaterialPage(child: AuthGate()),
    ),
    GoRoute(
      path: '/edit_product',

      pageBuilder: (context, state) {
        final product = state.extra as Product;
        return MaterialPage(child: EditProductPage( product:product,));
      },
    ),
    GoRoute(
      path: '/home',
      pageBuilder: (context, state) => MaterialPage(child: NavigationMenu(child: VendorDashboardScreen(),)),
    ),
    GoRoute(
      path: '/vendor_details',
      pageBuilder: (context, state) => MaterialPage(child: NavigationMenu(child: VendorDetailsPage(),)),
    ),
    GoRoute(
      path: '/add_product_flow',
      pageBuilder: (context, state) => MaterialPage(child: NavigationMenu(child: AddProductFlow(),)),
    ),


    GoRoute(
      path: '/all_products',
      pageBuilder: (context, state) => MaterialPage(child: NavigationMenu(child: MyProductsPage(),)),
    ),
    GoRoute(
      path: '/profile',
      pageBuilder: (context, state) => const MaterialPage(child:NavigationMenu(child: Profile(),)),
    ),
    GoRoute(
      path: '/signUp',
      pageBuilder: (context, state) =>  MaterialPage(child:SignUpPage()),
    ),
    GoRoute(
      path: '/signIn',
      pageBuilder: (context, state) =>  MaterialPage(child:SignInPage()),
    ),
    GoRoute(
      path: '/product-preview',
      pageBuilder: (context, state) {
        final product = state.extra as Product;
        return MaterialPage(child:ProductPreviewPage(product: product ,));
      },
    ),

  ],
);