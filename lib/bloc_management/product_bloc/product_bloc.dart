import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'product_state.dart';
import 'product_event.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';
import 'package:mime/mime.dart';




class ProductBloc extends Bloc<ProductEvent, ProductState>{


  SupabaseClient supabase = Supabase.instance.client;
  ProductBloc() : super(ProductLoadingState()){
    on<FetchProductsEvent>(_onFetchProducts);
    on<AddProductEvent>(_onAddProduct);
    on<UpdateProductEvent>(_onUpdateProduct);
    init();

  }

  String? vendorId;
  void init() async {
    var vendor = supabase.auth.currentUser;
    if (vendor != null) {
      vendorId = vendor.id;
    }
    else{
      throw Exception('vendor id null, yuklene bilmedi');
    }
  }
  final List<Product> products = [];


  //----------------------------------------------------------------

  Future<void> _onFetchProducts(
      FetchProductsEvent event,
      Emitter<ProductState> emit) async{

    if(vendorId == null){
      emit(ProductErrorState('vendor id null, yuklene bilmedi'));
      throw Exception('vendor id null, yuklene bilmedi');
    }
    try{
      emit(ProductLoadingState());
      final supabase = Supabase.instance.client;
      final response = await supabase.from('products').select().eq('vendor_id', vendorId!);

      for(var i in response){
        products.add(getProductFromJson(i));
      }

      emit(ProductLoadedState(products));



    }catch(e){
      debugPrint(e.toString());
    }

  }

  //----------------------------------------------------------------

  String generateShortUuid() {
    var uuid = Uuid();
    return uuid.v4().substring(0, 5).toUpperCase(); // Take first 5 chars
  }

  Future<List<dynamic>> stemWords(List<String> combinedWords) async {
    final url = Uri.parse("https://whatshoppy.pythonanywhere.com/stem");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "words": combinedWords
      }),
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      /*print("Response: $result"); // Debug response
      if (result.containsKey('original') && result.containsKey('stemmed')) {
        print('pyanywhere worked fine');
      } else {
        print("Error: Missing expected keys in the response.");
      }
*/
      return result['stemmed'];
    } else {
      debugPrint("Error: status code : ${response.statusCode}");
      return ['xeta bash verdi kod:25 33'];
    }
  }

  //----------------------------------------------------------------

  void saveToAWS(String fileName, Uint8List imgBytes) async{
    try {
      final contentType = lookupMimeType(fileName)?? 'application/octet-stream';;

      // STEP 1: Get signed URL
      print('Making request to backend...');
      final backendResponse = await http.post(
        Uri.parse('https://whatshoppy.pythonanywhere.com/get-upload-url'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'filename': fileName,
          'contentType': contentType,
        }),
      );

      if (backendResponse.statusCode != 200) {
        throw Exception('Backend request failed with status ${backendResponse.statusCode}');
      }

      final data = jsonDecode(backendResponse.body);
      final uploadUrl = data['uploadUrl'];
      final publicUrl = data['publicUrl'];

      await uploadToSignedUrl(uploadUrl, imgBytes, contentType);

      print('Upload URL: $uploadUrl');
      print('Public URL: $publicUrl');

      // Rest of your upload code...
    } catch (e) {
      print('Error in testAwsUploadFlow: $e');
    }

  }
  Future<void> uploadToSignedUrl(String signedUrl, Uint8List fileBytes, String contentType) async {
    final response = await http.put(
      Uri.parse(signedUrl),
      headers: {
        'Content-Type': contentType,
        'x-amz-acl': 'public-read', // this must match what the signed URL expects!
      },
      body: fileBytes,
    );
    if (response.statusCode != 200) {
      throw Exception('Upload failed with status ${response.statusCode}');
    }
  }

  String getPublicUrl(String imageName) {
    return "https://whatshop-bucket.s3.eu-north-1.amazonaws.com/uploads/$imageName";
  }
  //----------------------------------------------------------------
  Future<void> _onAddProduct(
      AddProductEvent event,
      Emitter<ProductState> emit) async{
    List<String> picPath = [];

    try{
      emit(ProductLoadingState());

      String productId = generateShortUuid();

      List<String> combinedWords  = event.name.split(' ') + event.description.split(' ') + productId.split(' ');


      for(var image in event.images){
        final File file = File(image.path);
        final Uint8List bytes = await file.readAsBytes();
        final String imageName = '$productId${image.path.split('/').last}';

        saveToAWS(imageName, bytes);
        print(picPath);

        picPath.add(getPublicUrl(imageName).toString());
      }


      final response = await supabase.from('products').insert({
        'product_id': productId,
        'name': event.name,
        'description': event.description,
        'category': event.category,
        'vendor_id': vendorId,
        'is_active': true,
        'pic_path': picPath,
        'rating_avg': 0.0,
        'size_price': event.sizeOptions,
        'colors': event.colorOptions,
        'created_at': DateTime.now().toIso8601String(),

      });


      await supabase.rpc('update_search_index_from_stems' , params: {
        'stemmed_words': List<String>.from(await stemWords(combinedWords)),
        'p_id': productId
      });
      debugPrint("debug No 1221 $response");
      picPath.clear();

      emit(ProductLoadedState(products));

    }catch(e){
      emit(ProductErrorState(e.toString()));
      debugPrint('error happened while adding product $e');
    }

  }



  Future<void> _onUpdateProduct (
      UpdateProductEvent event,
      Emitter<ProductState> emit
      ) async {
    try {
      emit(ProductLoadingState());
      await supabase
          .from('products')
          .delete()
          .eq('product_id', event.product.productId);


      products.removeWhere((element) => element.productId == event.product.productId);

      debugPrint('deleted succesfully');
      emit(ProductLoadedState(products));
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }
}



Product getProductFromJson(var item){
  return Product(
    isActive: item['is_active'] as bool,
    avgRating: (item['rating_avg'] as num?)?.toDouble()?? 0.0,

    colorOptions: item['colors'].map<Map<String,dynamic>>((e)=>{
      'color': e['color'].toString(),
      'isAvailable': e['isAvailable'] as bool
    }).toList(),
    images: item['pic_path'].cast<String>(),
    productId: item['product_id'],
    category: item['category'],
    name: item['name'],
    description: item['description'],
    sizeOptions: item['size_price'].map<Map<String,dynamic>>((e)=>{
      'size': e['size'].toString(),
      'price': (e['price'] as num).toDouble(),
      'isAvailable': e['isAvailable'] as bool
    }).toList(),
  );
}

class Product {
  final bool isActive;
  final double avgRating;
  final String name;
  final String description;
  final List<Map<String, dynamic>> sizeOptions;
  final List<String> images;
  final List<Map<String, dynamic>> colorOptions;
  final String category;
  final String productId;

  Product( {
    required this.isActive,
    required this.avgRating,
    required this.name,
    required this.description,
    required this.sizeOptions,
    required this.images,
    required this.colorOptions,
    required this.category,
    required this.productId,
  });
}

