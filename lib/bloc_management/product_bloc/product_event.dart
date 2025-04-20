import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatshop_vendor/bloc_management/product_bloc/product_bloc.dart';

abstract class ProductEvent extends Equatable{
  @override
  List<Object> get props =>[];
}

class FetchProductsEvent extends ProductEvent{}

class AddProductEvent extends ProductEvent{
  final String name;
  final String description;
  final List<Map<String,dynamic>> sizeOptions;
  final List<XFile> images;
  final List<Map<String,dynamic>> colorOptions;
  final String category;
  final String productId;

  AddProductEvent({
    required this.name,
    required this.description,
    required this.sizeOptions,
    required this.images,
    required this.colorOptions,
    required this.category,
    required this.productId,
});
}


class UpdateProductEvent extends ProductEvent{
  final Product product;
  UpdateProductEvent(this.product);
}



