import 'package:equatable/equatable.dart';

abstract class VendorEvent extends Equatable {
  const VendorEvent();

  @override
  List<Object?> get props => [];
}

class LoadVendorData extends VendorEvent {
  final String vendorId;

  const LoadVendorData(this.vendorId);

  @override
  List<Object?> get props => [vendorId];
}


