import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable{
  @override
  List<Object> get props =>[];
}

class FetchProductsEvent extends ProductEvent{}

class AddProductEvent extends ProductEvent{
  final Map<String, dynamic> product;
  AddProductEvent(this.product);
}

class ImagesSelectEvent extends ProductEvent{}



class UpdateProductEvent extends ProductEvent{
  final Map<String, dynamic> product;
  UpdateProductEvent(this.product);
}

