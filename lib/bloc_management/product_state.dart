import 'dart:typed_data';

import 'package:equatable/equatable.dart';


abstract class ProductState extends Equatable{
  @override
  List<Object?> get props => [];
}

class ProductLoadingState extends ProductState{}

class ProductUploadingState extends ProductState{
  final double progress;
  ProductUploadingState({required this.progress});
}
class ProductUploadedState extends ProductState{
  final List<ImageType> images;

  ProductUploadedState(this.images);
}


class ProductLoadedState extends ProductState{
  final List<Map<String,dynamic>> products;
  ProductLoadedState(this.products);

  @override
  List<Object?> get props =>[products];
}

class ProductErrorState extends ProductState{
  final String error;
  ProductErrorState(this.error);

  @override
  List<Object> get props =>[error];

}

class ProductPaginatingState extends ProductState{
  final List<Map<String, dynamic>> products;
  ProductPaginatingState(this.products);
  @override
  List<Object?> get props => [products];
}

class EndOfPageState extends ProductState{}

class EndOfProductsState extends ProductState{}




class ImageType {
  final String name;
  final Uint8List image;
  ImageType(this.name, this.image);
}