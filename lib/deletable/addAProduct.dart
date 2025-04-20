/*
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:whatshop_vendor/bloc_management/product_bloc/product_state.dart';
import 'package:whatshop_vendor/tools/colors.dart';
import 'package:whatshop_vendor/tools/variables.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc_management/product_bloc/product_bloc.dart';
import '../bloc_management/product_bloc/product_event.dart';
import '../bloc_management/size_cubit.dart';

class AddProduct extends StatelessWidget {
   AddProduct({super.key});


  final TextEditingController description = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController price = TextEditingController();
  final TextEditingController stock = TextEditingController();
  final TextEditingController sizes = TextEditingController();



  void resetState(){
    description.text = '';
    selectedCategory = '';
    name.text = '';
    price.text = '';
    stock.text = '';
    sizes.text = '';
  }
  final String selectedCategory = '';

   String generateShortUuid(String vendorId) {
     var uuid = Uuid();
     return '$vendorId${uuid.v4().substring(0, 5).toUpperCase()}'; // Take first 7 chars
   }



  @override
  Widget build(BuildContext context) {
    double widthSize = getWidthSize(context);
    double heightSize = getHeightSize(context);



    return Scaffold(
      appBar: AppBar(
        title: const Text("Mehsul Elave Edin"),
        centerTitle: true,
        leading: Icon(Icons.arrow_back_ios),
        actions: [
          IconButton(
              onPressed: (){
                BlocProvider.of<ProductBloc>(context).add(ImagesResetEvent());
              },
              icon: Icon(Icons.restart_alt)),
          IconButton(onPressed: (){
            BlocProvider.of<ProductBloc>(context).add(ImagesSelectEvent());
          }, icon: Icon(Icons.add_a_photo_rounded))
        ],
      ),
      body: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                        children: [
                Divider(color: dividerColor,height: 1,),
                SizedBox(height: 30,),
                SizedBox(
                  height: heightSize*0.20,
                  child: BlocBuilder<ProductBloc,ProductState>(
                    builder: (context,state) {
                      if(state is ProductUploadingState){
                        return LinearProgressIndicator();
                      }

                      else if(state is ProductUploadedState){
                        if(state.images.isEmpty){
                          return Center(
                            child: Column(
                              children: [

                                IconButton(onPressed: (){
                                  BlocProvider.of<ProductBloc>(context).add(ImagesResetEvent());
                                  BlocProvider.of<ProductBloc>(context).add(ImagesSelectEvent());
                                }, icon: SvgPicture.asset('assets/icons/placeholder.svg'),)
                              ],
                            ),
                          );
                        }{
                          return ListView.builder(
                            itemCount: state.images.length,
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: false,

                            itemBuilder: (context,index){
                              return Container(
                                margin:EdgeInsets.only(left: 10) ,

                                child: Image.memory(state.images[index].image),
                              );
                            },
                          );
                        }
                      }
                      if(state is ProductUploadingState){
                        return Center(
                          child: CircularProgressIndicator() ,
                        );
                      }
                      else if(state is ProductErrorState){
                        return Column(
                          children: [
                            Text('Yeniden Yoxlayin ,state'),
                            Center(
                              child: Column(
                                children: [

                                  IconButton(onPressed: (){
                                    BlocProvider.of<ProductBloc>(context).add(ImagesResetEvent());
                                    BlocProvider.of<ProductBloc>(context).add(ImagesSelectEvent());
                                  }, icon: SvgPicture.asset('assets/icons/placeholder.svg'),)
                                ],
                              ),
                            )
                          ],
                        );
                      }
                      else{
                        return Center(
                          child: Column(
                            children: [

                              IconButton(onPressed: (){
                                BlocProvider.of<ProductBloc>(context).add(ImagesResetEvent());
                                BlocProvider.of<ProductBloc>(context).add(ImagesSelectEvent());
                              }, icon: SvgPicture.asset('assets/icons/placeholder.svg'),)
                            ],
                          ),
                        );
                      }

                    }
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20,),
                      Text('       Məhsulun adı'),
                      SizedBox(height: 10,),
                      Center(
                        child: SizedBox(
                            width: widthSize*0.90,
                            height: heightSize*0.05,

                            child: TextField(

                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Məhsulun adını qeyd edin',
                                fillColor: dividerColor,

                                hintStyle: TextStyle(
                                  color: grayText,
                                ),
                                filled: true,
                              ),
                              style: TextStyle(
                                fontFamily: 'Tahoma',
                                fontSize: 15,
                              ),
                              controller: name,


                            )),
                      ),
                      SizedBox(height: 20,),
                      Text('       Məzmun'),
                      SizedBox(height: 10,),
                      Center(
                        child: SizedBox(
                            width: widthSize*0.90,
                            height: heightSize*0.2,

                            child: TextField(
                              maxLines: 15,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Vacib məqamları qeyd edin',
                                fillColor: dividerColor,
                                hintStyle: TextStyle(
                                  color: grayText,
                                ),
                                filled: true,
                              ),
                              controller: description,
                              keyboardType: TextInputType.multiline,
                              style: TextStyle(
                                fontSize: 15,
                              ),
                              autocorrect: false ,


                            )),
                      ),
                      SizedBox(height: 20,),
                      Text('       Kategoriya'),
                      Padding(

                        padding: const EdgeInsets.all(18.0),
                        child: GestureDetector(
                          onTap: ()=>chooseCategory(context),
                          child: Center(child: Container(
                              width: widthSize*0.85,
                              height: 52,
                              decoration: BoxDecoration(
                                color: dividerColor,
                                border: Border.all(
                                  width: 1,
                                  color: Colors.black87
                                )
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text('Meselen : usaq geyimleri',
                                style: TextStyle(
                                  color: Colors.black45,
                                  fontSize: 15
                                ),
                                ),
                              ))),
                        )
                      ),
                      SizedBox(height: 20,),

                      BlocProvider(
                        create: (context) => SizeCubit([]),
                        child: BlocBuilder<SizeCubit,List<SizePrice>>(
                          builder: (context,state) {
                            TextEditingController sizeController = TextEditingController();
                            TextEditingController priceController = TextEditingController();

                            return ListView.builder(
                              itemCount: 2,
                              shrinkWrap: true,
                              itemBuilder: (context,index){
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                                  child: Wrap(
                                    direction: Axis.horizontal,
                                    spacing: 4,
                                    runSpacing: 4,
                                    children: [
                                      SizedBox(
                                        width: 140,
                                        child: Row(
                                          children: [
                                            Text('Olcu_ '),
                                            Expanded(
                                              child: Container(
                                                color: Colors.green,
                                                height: 60,child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Center(
                                                    child: CupertinoTextField(
                                                      controller: sizeController,

                                                      style: TextStyle(
                                                          fontSize: 24
                                                      ),
                                                      maxLength: 10,
                                                    )),
                                              ),
                                              ),
                                            ),

                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 10,),
                                      SizedBox(
                                        width: 160,
                                        child: Row(
                                          children: [
                                            Text('Qiymet_ '),
                                            Expanded(
                                              child: Container(
                                                color: Colors.green,
                                                height: 60,child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Center(
                                                    child: CupertinoTextField(
                                                      controller: priceController,
                                                      style: TextStyle(
                                                          fontSize: 24
                                                      ),
                                                      maxLength: 10,
                                                    )),
                                              ),
                                              ),
                                            ),

                                          ],
                                        ),
                                      ),
                                      GestureDetector(
                                          onTap: (){

                                          },
                                          child: Icon(Icons.delete_forever_sharp,size: 40,color: Colors.red,)
                                      ),
                                      SizedBox(height: 20,),
                                      GestureDetector(
                                        onTap: (){},
                                        child: Center(
                                          child: Container(
                                            width: 300,
                                            height: 43,
                                            color: Colors.tealAccent,
                                            child: Center(child: Text('+ Yeni olcu ve qiymet elave edin',style: TextStyle(
                                                color: Colors.black87,fontSize: 16
                                            ),)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },

                            );
                          }
                        ),
                      ),
                      SizedBox(height: 40,),
                      Text('       Məhsul sayı'),
                      Center(
                        child: SizedBox(
                            width: widthSize*0.90,
                            height: heightSize*0.05,

                            child: TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Məhsul sayı ( satış üçün nəzərdə tutulan)',
                                fillColor: dividerColor,
                                hintStyle: TextStyle(
                                  color: grayText,
                                ),
                                filled: true,
                              ),
                              controller: stock,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              style: TextStyle(
                                fontSize: 15,
                              ),
                              autocorrect: false,

                            )),
                      ),



                    ],
                  ),
                ),
                          SizedBox(height: 60,),
                          */
/*GestureDetector(
                              onTap: (){
                                Map<String,dynamic> product = {
                                  'product_id': generateShortUuid('V1'),
                                  'price': double.tryParse(price.text),
                                  'name': name.text,
                                  'description': description.text,
                                  'stock': stock.text,
                                  'sizes': sizes.text.split(','),
                                  'created_at': DateTime.now().toIso8601String(),
                                  'category': selectedCategory
                                };
                                BlocProvider.of<ProductBloc>(context).add(AddProductEvent(
                                    Product(

                                  productId: product['product_id'],
                                  name: product['name'],
                                  description: product['description'],

                                  sizes: product['sizes'],
                                  createdAt: product['created_at'],
                                  category: product['category'],
                                  images: []
                                )));
                              },
                              child: Container(
                              width: widthSize*0.7,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: mainBlue,
                                  borderRadius: BorderRadius.circular(20)
                                ),
                              child: Center(
                                child: Text('Dərc et',style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                                ),),
                              ),
                              ),
                          ),*//*

                          SizedBox(height: 120,),


                        ],
                      ),
              ),
              BlocBuilder<ProductBloc,ProductState>(
                builder: (context,state) {
                  if(state is ProductOnboardedState){
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      resetState(); // Now safe to call
                    });
                    return Center(
                     child: Container(
                       width: widthSize*0.7,
                       height: 260,
                       decoration: BoxDecoration(
                           color: mainBlue,
                           borderRadius: BorderRadius.circular(20)),
                       child: Column(
                         mainAxisSize: MainAxisSize.min,
                         children: [
                           Icon(Icons.check_box, size: 100,color: Colors.green,),
                           Text('Dərc olundu',style: TextStyle(
                             color: Colors.white,
                             fontSize: 20,
                             fontWeight: FontWeight.bold
                           ),),
                           SizedBox(height: 10,),
                         ],
                       ),
                     )
                    );
                  }
                  else if(state is ProductOnboardingState){
                    return Center(
                        child:CircularProgressIndicator()
                    );
                  }
                  else{
                    return Container();
                  }

                }
              )
            ],
          )),

    );
  }
}



void chooseCategory(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Padding(
          padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      builder: (_, controller) => Container(
      color: mainBlue,
      width: getWidthSize(context),
      child: SafeArea( child: Container(
          width: getWidthSize(context)*0.9,
          height: 800,
          child: ListView.builder(
              itemCount: 15,
              itemBuilder: (context,index){
            return ListTile(
              tileColor: CupertinoColors.systemTeal,
              title: Text('kategori $index'),
            );
          }
          ),
        )
      )
      )
      )
      );

  });

}


*/
