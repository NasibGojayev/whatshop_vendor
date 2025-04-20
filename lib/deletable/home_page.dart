/*
import 'package:flutter/material.dart';
import 'package:whatshop_vendor/deletable/add_product.dart';
import 'package:whatshop_vendor/tools/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc_management/product_bloc/product_bloc.dart';
import '../bloc_management/product_bloc/product_event.dart';
import '../bloc_management/product_bloc/product_state.dart';
import '../tools/variables.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    //double widthSize = getWidthSize(context);
    //double heightSize = getHeightSize(context);
    int crossAxisCount = getCrossAxisCount(context);
    double childAspectRatio = getChildAspectRatio(context);

    return Scaffold(
        body: SafeArea(child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(onPressed: (){}, icon: Icon(Icons.view_headline)),
                  IconButton(onPressed: (){}, icon: Icon(Icons.remove_red_eye_rounded)),
                  IconButton(onPressed: (){
                    context.read<ProductBloc>().add(FetchProductsEvent());
                  }, icon: Icon(Icons.refresh))
                ],
              ),
              Divider(height: 1,color: Colors.grey,),
              SizedBox(height: 10,),
              Text('Xosh Geldiniz',style: TextStyle(
                  color: grayText,
                  fontSize: 15,
                  fontWeight: FontWeight.w100
              ),),
              SizedBox(height: 6,),


              Text('Ilhame Qocayeva',style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
              ),),
              SizedBox(height: 13,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Mehsullarim',style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700
                  ),),
                  GestureDetector(
                    onTap: (){},
                    child: Row(
                      children: [
                        Text('Vaxta gore',style: TextStyle(
                            fontSize: 15,
                            color: grayText,
                            fontWeight: FontWeight.w100
                        ),),
                        Icon(Icons.keyboard_arrow_down_rounded)
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10,),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BlocBuilder<ProductBloc, ProductState>(
                    builder: (context, state) {
                      if(state is ProductLoadingState){
                        return Center(child: CircularProgressIndicator());
                      }
                      else if(state is ProductLoadedState){

                        return GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                crossAxisSpacing: 8.0,
                                mainAxisSpacing: 8.0,
                                childAspectRatio: childAspectRatio
                            ),
                            itemCount: state.products.length,
                            itemBuilder: (context,index){
                              var product = state.products[index];
                              return Item(id: product.productId , onPressed:(){},icon: IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('Delete Product'),
                                      content: Text('Are you sure you want to delete this product?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            context.read<ProductBloc>().add(
                                                UpdateProductEvent(product)
                                            );
                                            // Optionally refresh your product list
                                          },
                                          child: Text('Delete', style: TextStyle(color: Colors.red)),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ), image: Image.network(product.images[0]), name: product.name, price: product.sizeOptions[0].price);
                            });
                      }
                      else{
                        return state is ProductErrorState? Text(state.error):Center(child: Text('Məhsul Yükləme Veziyyeti'));
                      }
                    }
                  ),
                ),
              ),
            ],
          ),
        )));
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
}*/
