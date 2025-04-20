/*
import 'package:flutter/material.dart';
import 'package:whatshop_vendor/bloc_management/product_bloc.dart';
import 'package:whatshop_vendor/bloc_management/product_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatshop_vendor/bloc_management/product_event.dart';

class PlayGroundSup extends StatelessWidget {
  const PlayGroundSup({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String,dynamic>> instruments = [];
    return Scaffold(
        appBar: AppBar(title: const Text('Instruments')),
        body: Column(
          children: [
            Container(
              color: Colors.grey,
              width: 400,
              height: 500,
              child: BlocBuilder<ProductBloc,ProductState>(
                builder: (context,state) {
                  if(state is ProductLoadedState){
                    return ListView.builder(
                        itemCount: state.products.length,
                        itemBuilder: (context,index){
                          final product = state.products[index];
                          return Item(
                            id: product['product_id'],
                            onPressed: (){

                            },
                            image: Image.network("${product['pic_path']}"),
                            name: product['name'],
                            price: product['price'],
                            icon: Icon(Icons.check_box_outline_blank,size: 30,),
                          );
                        });
                  }
                  else return Center(child: CircularProgressIndicator(color: Colors.red,));
                }
              ),
            ),
            ElevatedButton(onPressed: (){
              BlocProvider.of<ProductBloc>(context).add(FetchProductsEvent());
            }, child: Text('Fetch'))
          ],
        )
    );
  }
}

*/
