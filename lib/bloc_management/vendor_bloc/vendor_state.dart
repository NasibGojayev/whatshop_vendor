import 'package:equatable/equatable.dart';

class Vendor {
  final String vendorId;
  final String name;
  final String avatarPic;
  final String email;
  final int totalSales;
  final List<String> products;
  final DateTime createdAt;
  final String phone;
  final String description;
  final String shopImg;
  final String shopName;
  final String shopLocation;
  final List<String> activeProducts;
  Vendor({
    required this.activeProducts,
    required this.vendorId,
    required this.name,
    required this.avatarPic,
    required this.email,
    required this.totalSales,
    required this.products,
    required this.createdAt,
    required this.phone,
    required this.description,
    required this.shopImg,
    required this.shopName,
    required this.shopLocation,
});

  factory Vendor.fromJson(Map<String, dynamic> json) {
    return Vendor(
      activeProducts: List<String>.from(json['active_products']),
      vendorId: json['vendor_id'],
      name: json['name'],
      avatarPic: json['avatar_pic'],
      email: json['email'],
      totalSales: json['total_sales'],
      products: List<String>.from(json['products']),
      createdAt: DateTime.parse(json['created_at']),
      phone: json['phone'],
      description: json['description'],
      shopImg: json['shop_image'],
      shopName: json['shop_name'],
      shopLocation: json['address'],
    );
  }
  Map<String, dynamic> toJson() {
    return{
      'vendor_id': vendorId,
      'name': name,
      'avatar_pic': avatarPic,
      'email': email,
      'total_sales': totalSales,
      'products': products,
      'created_at': createdAt.toIso8601String(),
      'phone': phone,
      'description': description,
      'shop_image': shopImg,
      'shop_name': shopName,
      'address': shopLocation,
      'activeProducts': activeProducts
    };
  }




}

abstract class VendorState extends Equatable {
  const VendorState();

  @override
  List<Object?> get props => [];
}

class VendorInitial extends VendorState {}

class VendorLoading extends VendorState {}

class VendorLoaded extends VendorState {
  final Vendor vendor;
  final List<PreProduct> preProducts;


  const VendorLoaded({ required this.vendor ,required this.preProducts});

  @override
  List<Object?> get props => [vendor];
}

class VendorError extends VendorState {
  final String message;

  const VendorError(this.message);

  @override
  List<Object?> get props => [message];
}

class PreProduct{
  final String productId;
  final String name;
  final bool isActive;
  PreProduct({required this.productId,required this.name,required this.isActive});
}