/*
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:whatshop_vendor/tools/google_cloud_api.dart';

import '../bloc_management/product_bloc.dart';
import '../bloc_management/product_event.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  File? _image;
  Uint8List? _imageBytes;
  String? imageName;
  final picker = ImagePicker();
  CloudApi? api;

  @override
  void initState() { 
    super.initState();
    rootBundle.loadString('assets/credentials.json').then((json){
      api = CloudApi(json);
    });
  }



  TextEditingController _productName = TextEditingController();
  TextEditingController _description = TextEditingController();
  TextEditingController _price = TextEditingController();

  TextEditingController _stock = TextEditingController();


  String generateShortUuid(String vendorId) {
    var uuid = Uuid();
    return '$vendorId${uuid.v4().substring(0, 5).toUpperCase()}'; // Take first 7 chars
  }


  void _getImage() async{
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if(pickedFile != null){
      _image = File(pickedFile.path);
      _imageBytes = await _image!.readAsBytes();
      imageName = 'firstvendor${pickedFile.path.split('/').last}';
      print(imageName);
      setState(() {});
    }
  }

  void saveImage() async{
    final response = await api!.save(imageName!, _imageBytes!);
    print(response.downloadLink);
  }
  String getPublicUrl(String imageName) {
    return "https://storage.googleapis.com/whatshop_bucket/$imageName";
  }
  Map<String, dynamic> product ={};

  @override
  Widget build(BuildContext context) {
    double widthSize = MediaQuery.of(context).size.width;
    double heightSize = MediaQuery.of(context).size.height;



    return Scaffold(
      floatingActionButton: FloatingActionButton(

        onPressed: _getImage,
        backgroundColor: Colors.red,
        child: Icon(Icons.add,color:Colors.white),
      ),
      appBar: AppBar(
        title: const Text("Product List"),
      ),
      body: SafeArea(
          child: //_imageBytes == null? Text('no image'):
          SingleChildScrollView(
            child: SizedBox(
              width: widthSize*0.9,
              height: heightSize*0.7,
              child: Column(

                children: [
                  Column(

                    children: [
                      CupertinoTextField(
                        decoration: BoxDecoration(
                            color: Color(0xFFECECEC)
                        ),
                        cursorColor: Colors.black,


                        controller: _productName,
                        placeholder: 'mehsulun adi',
                      ),
                      SizedBox(height: 20),
                      CupertinoTextField(
                        decoration: BoxDecoration(
                            color: Color(0xFFECECEC)
                        ),
                        cursorColor: Colors.black,

                        controller: _description,
                        placeholder: 'haqqinda',
                      ),
                      SizedBox(height: 20),

                      CupertinoTextField(
                        decoration: BoxDecoration(
                            color: Color(0xFFECECEC)
                        ),
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))
                        ],

                        controller: _price,
                        placeholder: 'qiymeti',
                      ),
                      SizedBox(height: 20),
                      CupertinoTextField(
                        decoration: BoxDecoration(
                            color: Color(0xFFECECEC)
                        ),
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        controller: _stock,
                        placeholder: 'sayi',
                      ),
                    ],
                  ),
                  _imageBytes==null? Text('no image'):Image.memory(_imageBytes!,width: widthSize*0.5,),
                  Align(
                    alignment: Alignment.bottomCenter,

                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                        ),
                        onPressed: (){

                          saveImage();
                          String picPath = getPublicUrl(imageName!);
                          print(picPath);


                          product = {
                            'product_id': generateShortUuid('V1'),
                            'price': double.tryParse(_price.text),
                            'name': _productName.text,
                            'description': _description.text,
                            'stock': _stock.text,
                            'pic_path': picPath,
                            'sizes':[
                              'M',
                              'L',
                              'XL',
                              'XXL'
                            ],
                            'created_at': DateTime.now().toIso8601String(),
                            'category': 'shoe_00'
                          };

                          BlocProvider.of<ProductBloc>(context).add(AddProductEvent(product));

                        }, child: Text('Elave et',style: TextStyle(
                        color: Colors.white
                    ),)),
                  )
                ],
              ),
            ),
          )
      ),
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
      color: Colors.grey[200], // Light grey background
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
*/
