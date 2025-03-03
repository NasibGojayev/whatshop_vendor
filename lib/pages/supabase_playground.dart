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

class Item extends StatelessWidget {

  final Image image;
  final String id;
  final String name;
  final num price;
  final Widget icon;
  final VoidCallback onPressed;
  const Item({
    super.key,
    required this.id,
    required this.icon,
    required this.onPressed,
    required this.image,
    required this.name,
    required this.price,

  });



  @override
  Widget build(BuildContext context) {
    //double widthSize = MediaQuery.of(context).size.width;
    //double heightSize = MediaQuery.of(context).size.height;
    return Container(
      color: Colors.grey, // Light grey background
      child: Column(
        mainAxisSize: MainAxisSize.min, // Allow content to grow naturally
        children: [
          Align(
              alignment: Alignment.topRight,
              child: IconButton(onPressed: onPressed, icon: icon)),

          Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            clipBehavior: Clip.hardEdge, // Clip content to fit within rounded corners
            child: image,
          ),
          SizedBox(height: 8),
          Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black.withValues(alpha: 0.45),
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4),
          Text(
            "$price AZN", // Assuming price is a double value, adding a '$' symbol
            style: TextStyle(
              color: Color(0xFF1E1E1E),
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
