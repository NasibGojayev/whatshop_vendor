import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatshop_vendor/bloc_management/vendor_bloc/vendor_bloc.dart';
import 'package:whatshop_vendor/tools/app_route_config.dart';
import 'bloc_management/product_bloc/product_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'bloc_management/product_bloc/product_event.dart';
void main() async {

  WidgetsFlutterBinding.ensureInitialized(); // Ensure initialization
  try {


    await Supabase.initialize(
      url: 'https://lwdszubkpfrnyduswzfs.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imx3ZHN6dWJrcGZybnlkdXN3emZzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDA0MzE4NjEsImV4cCI6MjA1NjAwNzg2MX0.gcDrC8YPB3G_kRqHYZd54QBFJJqI1J17O4zrisrm73Q',
    );

    runApp(MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => ProductBloc()),
        ],
        child: MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => ProductBloc()..add(FetchProductsEvent())),
              BlocProvider(create: (context) => VendorBloc()),
              //BlocProvider(create: (context) => NavigatorCubit()),
            ],
            child: const MyApp())));
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(

      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.lexendDecaTextTheme(),
      ),
      title: 'Vendor App',
      routerConfig: router,
    );
  }
}


