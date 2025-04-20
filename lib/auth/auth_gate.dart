/*

AUTH GATE --- THIS WILL CONTUNIOUSLY CHECK IF THE USER IS LOGGED IN OR NOT

 */


import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:whatshop_vendor/auth/sign_in.dart';
import 'package:whatshop_vendor/pages/dashboard.dart';
import '../tools/navigation_menu.dart';


class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
      //listen to auth state changes
        stream: Supabase.instance.client.auth.onAuthStateChange,

        builder: (context, snapshot){

          if(snapshot.connectionState == ConnectionState.waiting){
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          final session = snapshot.hasData?snapshot.data!.session:null;
          if(session == null){
            return SignInPage();
          }
          else{
            return NavigationMenu(child: VendorDashboardScreen(),);
          }
        });
  }
}