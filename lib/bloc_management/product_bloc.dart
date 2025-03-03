import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../tools/api.dart';
import 'product_state.dart';
import 'product_event.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';



class ProductBloc extends Bloc<ProductEvent, ProductState>{
  ProductBloc() : super(ProductLoadingState()){
    on<FetchProductsEvent>(_onFetchProducts);
    on<AddProductEvent>(_onAddProduct);
    on<UpdateProductEvent>(_onUpdateProduct);
    on<ImagesSelectEvent>(_onImageUpload);
    initState();
  }

  CloudApi? api;
  void initState(){
    rootBundle.loadString('assets/credentials.json').then((json){
      api = CloudApi(json);
    });
  }

  List<String> pic_path = [];

  void saveImage(String name, Uint8List imgBytes) async{
    final response = await api!.save(name, imgBytes);
    print('succesfully saved to ${response.downloadLink}');
  }
  String getPublicUrl(String imageName) {
    return "https://storage.googleapis.com/whatshop_bucket/$imageName";
  }


  final List<ImageType> images = [];

  Future<void> _onImageUpload(
      ImagesSelectEvent event,
      Emitter<ProductState> emit) async{


    final ImagePicker picker = ImagePicker();
    final List<XFile> selectedImages = await picker.pickMultiImage();

    if(selectedImages.isNotEmpty){
      emit(ProductUploadingState(progress: 0));

      for(var image in selectedImages){
        final File file = File(image.path);
        final Uint8List bytes = await file.readAsBytes();
        final String imageName = 'fv${image.path.split('/').last}';
        images.add(ImageType(imageName, bytes));
        pic_path!.add(getPublicUrl(imageName));
      }
      emit(ProductUploadedState(images));

    }
    else{
      emit(ProductErrorState('No images selected'));
    }

  }

  Future<void> _onFetchProducts(
      FetchProductsEvent event,
      Emitter<ProductState> emit) async{

    try{

      final supabase = Supabase.instance.client;

      final response = await supabase.from('products').select();
      print(response);

      emit(ProductLoadedState(response));



    }catch(e){
      print(e);
    }

  }
  Future<void> _onAddProduct(
      AddProductEvent event,
      Emitter<ProductState> emit) async{

    try{

      emit(ProductUploadingState(progress: 0));

      // Simulate product upload process with progress
      for (int i = 1; i <= 10; i++) {
        await Future.delayed(Duration(milliseconds: 300));
        emit(ProductUploadingState(progress: i * 10)); // Update progress in steps of 10%
      }

      for(var image in images){

        saveImage(image.name, image.image);

        pic_path.add(getPublicUrl(image.name).toString());
        print(pic_path);
      }
      event.product['pic_path'] = pic_path;

      final supabase = Supabase.instance.client;
      final response = await supabase.from('products').insert([event.product]);
      print("nasib ${response}");

      emit(ProductUploadedState(images));


    }catch(e){
      emit(ProductErrorState(e.toString()));
      print(e);
    }

  }



  Future<void> _onUpdateProduct(
      UpdateProductEvent event,
      Emitter<ProductState> emit) async{

    try{

    }catch(e){
      print(e);
    }

  }

}