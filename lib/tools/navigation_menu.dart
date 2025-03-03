import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatshop_vendor/pages/add_product.dart';
import 'package:whatshop_vendor/tools/colors.dart';

import '../addAProduct.dart';
import '../pages/home_page.dart';
import '../pages/profile.dart';



class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: mainBlue,
            ),
            child: IconButton(
              onPressed: () {
                context.read<NavigatorCubit>().changeIndex(1);
              },
              icon: Icon(Icons.add,color: Colors.white,),
            ),

          ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BlocBuilder<NavigatorCubit,int>(
              builder: (context,state) {
              return NavigationBar(
                  height: 80,
                  elevation: 0,
                  selectedIndex: state,
                  onDestinationSelected: (index) =>
                      context.read<NavigatorCubit>().changeIndex(index),
                  destinations: const[
                    NavigationDestination(icon: Icon(Icons.home), label: 'Ana səhifə'),
                    NavigationDestination(icon: Icon(Icons.add), label: 'Sat'),
                    NavigationDestination(
                        icon: Icon(Icons.manage_accounts), label: 'Profil'),

                  ]
              );
            }
          ),
          body: BlocBuilder<NavigatorCubit,int>(
            builder: (context,state) {
              return context.read<NavigatorCubit>().pages[state];
            }
          ),
        );
  }
}

class NavigatorCubit extends Cubit<int>{
  NavigatorCubit():super(0);
  void changeIndex(int index){
    emit(index);
  }
  final pages = [
    HomePage(),
    AddAProduct(),
    AddProduct(),

  ];
}
