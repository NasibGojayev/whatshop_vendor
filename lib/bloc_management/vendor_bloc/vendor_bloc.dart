import 'package:flutter_bloc/flutter_bloc.dart';
import 'vendor_event.dart';
import 'vendor_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VendorBloc extends Bloc<VendorEvent, VendorState> {
  SupabaseClient supabase = Supabase.instance.client;

  VendorBloc() : super(VendorInitial()) {
    on<LoadVendorData>(_onLoadVendorData);
    init();
  }


  String? vendorId;
  void init() async {
    var vendor = supabase.auth.currentUser;
    if (vendor != null) {
      vendorId = vendor.id;
      add(LoadVendorData(vendorId!));
    }
    else{
      throw Exception('vendor id null, yuklene bilmedi');
    }


  }
  Future<List<PreProduct>> getPreProducts(String vendorId) async {
    try{
      List<PreProduct> preProducts = [];
      var json = await supabase.from('products').select().eq('vendor_id', vendorId).limit(5);

      for (var product in json) {
        preProducts.add(PreProduct(productId: product['product_id'] as String, name: product['name'] as String, isActive: product['is_active'] as bool));
      }
      return preProducts;
    }catch(e){
      throw Exception("PreProduct məlumatı alınmadı.$e");
    }
  }


  Future<void> _onLoadVendorData(
      LoadVendorData event,
      Emitter<VendorState> emit,
      ) async {
    emit(VendorLoading());

    try {
      final preProducts = await getPreProducts(event.vendorId);

      var json = await supabase.from('vendors').select().eq('vendor_id', event.vendorId).single();
      final vendor = Vendor.fromJson(json);

      emit(VendorLoaded(vendor:vendor,preProducts: preProducts));

    } catch (e) {
      emit(VendorError('Vendor məlumatı alınmadı.$e'));
    }
  }

}
