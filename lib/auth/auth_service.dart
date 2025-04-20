import 'dart:math';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService{
  
  SupabaseClient supabase = Supabase.instance.client;

  Future<AuthResponse> signInWithEmailAndPassword(String email, String password) async{



      var response  = await supabase.auth.signInWithPassword(email: email, password: password);
      if(response.user != null){

        var json = await supabase.from('all_profiles').select('role').eq('id', response.user!.id).single();
        if(json['role'] == 'vendor'){
          return response;
        }
        else{
          throw Exception('sen vendor deyilsen code not-a-vendor#344');
        }
      }
      else {
        throw Exception('Sign In failed with the following error: WpVendor SignIn');
      }

  }
  
  Future<AuthResponse> signUpWithEmailAndPassword(Vendor vendor) async{
    try{


      var response  = await supabase.auth.signUp(email: vendor.email, password: vendor.password);
      await supabase.from('all_profiles').insert({
        'id': response.user!.id,
        'role': 'vendor',
      });
      if(response.user != null){

        await addVendorToDatabase(vendor, response.user!.id);
        return response;
      }
      else {
        throw Exception('Sign Up failed with the following error: WpVendor SignUp');
      }
    }catch(e){
      debugPrint(
        'Error signing up with email and password: $e',
      );
      rethrow;
    }
  }


  Future<void> addVendorToDatabase(Vendor vendor,String vendorId) async{
    try{
      await supabase.from('vendors').insert({
        'vendor_id': vendorId,
        'name': '${vendor.name} ${vendor.surname}',
        'shop_name': vendor.shopName,
        'address': vendor.shopLocation,
        'phone': vendor.mobile,
        'email':vendor.email,
        'created_at': DateTime.now().toIso8601String(),

      });
    }catch(e){
      debugPrint(
        'Error adding vendor to database: $e',
      );
      rethrow;
    }
  }


  Future<String> generateUniqueUsername(String fullName) async {
    final SupabaseClient supabase = Supabase.instance.client;

    // Step 1: Make the base username
    String baseUsername = fullName.toLowerCase().replaceAll(' ', '');
    String username = '@$baseUsername';

    // Step 2: Check if username exists
    var existing = await supabase.from('vendors').select("vendor_id").eq('vendor_id', username);

    int attempt = 0;
    Random random = Random();

    // Step 3: If exists, add random numbers
    while (existing.isNotEmpty) {
      attempt++;
      int randomNumber = random.nextInt(900) + 100; // 100-999
      username = '@$baseUsername$randomNumber';

      existing =
      await supabase.from('vendors').select('vendor_id').eq('vendor_id', username);

      // Safety break if somehow gets stuck
      if (attempt > 20) {
        throw Exception('Failed to generate unique username');
      }
    }

    return username;
  }
  
  
}






class Vendor{
  String name;
  String surname;
  String shopName;
  String shopLocation;
  String mobile;
  String email;
  String password;

  Vendor({
    required this.name,
    required this.surname,
    required this.shopName,
    required this.shopLocation,
    required this.password,
    required this.mobile,
    required this.email,
});
}