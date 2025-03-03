import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:whatshop_vendor/bloc_management/product_state.dart';
import 'package:whatshop_vendor/tools/colors.dart';
import 'package:whatshop_vendor/tools/variables.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc_management/product_bloc.dart';
import 'bloc_management/product_event.dart';

class AddAProduct extends StatelessWidget {
   AddAProduct({super.key});


  final TextEditingController description = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController price = TextEditingController();
  final TextEditingController stock = TextEditingController();
  final TextEditingController sizes = TextEditingController();
  final List<DropdownMenuItem> categories = [
    const DropdownMenuItem(
        child: Text("Ayaqqabi"),
        value: "shoe_00"
    ),
    const DropdownMenuItem(
        child: Text("Elektronika"),
        value: "electronics_00"
    ),
    const DropdownMenuItem(
        child: Text("Geyim"),
        value: "clothing_00"
    ),
    const DropdownMenuItem(
        child: Text("Aksesuarlar"),
        value: "accessories_00"
    ),

  ];
  String? selectedCategory;

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
                  height: heightSize*0.15,
                  child: BlocBuilder<ProductBloc,ProductState>(
                    builder: (context,state) {
                      if(state is ProductUploadingState){
                        return Stack(
                          children: [
                            Opacity(
                              opacity: 0.3,
                              child: Center(child: Text("Uploading...")),
                            ),
                            Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircularProgressIndicator(value: state.progress / 100),
                                  SizedBox(height: 10),
                                  Text("${state.progress.toStringAsFixed(0)}%"),
                                ],
                              ),
                            ),
                          ],
                        );
                      }

                      else if(state is ProductUploadedState){
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
                      if(state is ProductUploadingState){
                        return Center(
                          child: CircularProgressIndicator() ,
                        );
                      }
                      else{
                        return Center(
                          child: Column(
                            children: [

                              IconButton(onPressed: (){
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
                              controller: name,
                              keyboardType: TextInputType.name,

                              style: TextStyle(
                                fontSize: 15,
                              ),
                              autocorrect: false,



                            )),
                      ),
                      SizedBox(height: 20,),
                      Text('       Məzmun'),
                      SizedBox(height: 10,),
                      Center(
                        child: Container(
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
                      SizedBox(height: 10,),
                      Padding(

                        padding: const EdgeInsets.all(18.0),
                        child: DropdownButtonFormField(

                          icon:  SvgPicture.asset('assets/icons/category.svg',width: 40,height: 40,),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Kategoriya seçin',
                            fillColor: dividerColor,
                            hintStyle: TextStyle(),),
                          items: categories, onChanged: (value){
                            selectedCategory = value;
                        },
                        ),
                      ),
                      SizedBox(height: 20,),

                      Text('       Olculer (vergul qoyaraq yazin)'),
                      Center(
                        child: SizedBox(
                            width: widthSize*0.90,
                            height: heightSize*0.05,

                            child: TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Məhsulun olculerini qeyd edin',
                                fillColor: dividerColor,
                                hintStyle: TextStyle(
                                  color: grayText,
                                ),
                                filled: true,
                              ),
                              controller: sizes,
                              keyboardType: TextInputType.name,
                              style: TextStyle(
                                fontSize: 15,
                              ),
                              autocorrect: false,


                            )),
                      ),

                      SizedBox(height: 20,),
                      Text('       Qiymet / AZN'),
                      Center(
                        child: SizedBox(
                            width: widthSize*0.90,
                            height: heightSize*0.05,

                            child: TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Məhsulun qiymeti (manatla)',
                                fillColor: dividerColor,
                                hintStyle: TextStyle(
                                  color: grayText,
                                ),
                                filled: true,
                              ),
                              controller: price,
                              keyboardType: TextInputType.number,

                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))
                              ],
                              style: TextStyle(
                                fontSize: 15,
                              ),
                              autocorrect: false,

                            )),
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
                          GestureDetector(
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
                                BlocProvider.of<ProductBloc>(context).add(AddProductEvent(product));
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
                          ),
                          SizedBox(height: 120,),

                        ],
                      ),
              ),
            ],
          )),

    );
  }
}
