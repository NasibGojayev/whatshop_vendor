import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:whatshop_vendor/tools/colors.dart';

import 'auth_service.dart';



class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _shopNameController = TextEditingController();
  final _shopLocationController = TextEditingController();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _shopNameController.dispose();
    _shopLocationController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }
  void resetFields() {
    _nameController.clear();
    _surnameController.clear();
    _shopNameController.clear();
    _shopLocationController.clear();
    _mobileController.clear();
    _passwordController.clear();
    _emailController.clear();

  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Zəhmət olmasa adınızı yazın';
    }
    return null;
  }

  String? _validateSurname(String? value) {
    if (value == null || value.isEmpty) {
      return 'Zəhmət olmasa soyadınızı yazın';
    }
    return null;
  }

  String? _validateShopName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Zəhmət olmasa Mağaza adını yazın';
    }
    return null;
  }

  String? _validateShopLocation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Zəhmət olmasa ünvanınızı yazın';
    }
    return null;
  }

  String? _validateMobile(String? value) {
    if (value == null || value.isEmpty) {
      return 'Zəhmət olmasa telefon nömrənizi yazın';
    }
    if (value.length < 10) {
      return 'Düzgün nömrə yazın';
    }
    return null;
  }
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Zəhmət olmasa email adresinizi yazın';
    }
    if (!value.contains('@')) {
      return 'Düzgün email adresi yazın';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Zəhmət olmasa şifrənizi yazın';
    }
    if (value.length < 6) {
      return 'Şifrə ən azı 6 xanadan ibarət olmalıdır';
    }
    return null;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {

      final Vendor vendor = Vendor(
        email: _emailController.text,
        name: _nameController.text,
        surname: _surnameController.text,
        shopName: _shopNameController.text,
        shopLocation: _shopLocationController.text,
        mobile: _mobileController.text,
        password: _passwordController.text,
      );

      debugPrint('User Data: $vendor');
      try{
        AuthService().signUpWithEmailAndPassword(vendor);
        resetFields();
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Qeydiyyat uğurlu oldu'),
            content: Text('Sizin Mağazanınız uğurla yaradıldı.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  //context.go('/addProduct');
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      }catch(e){
        debugPrint('Error: $e');
      }


    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 40),
                Column(
                  children: [
                    Icon(
                      Icons.store,
                      size: 80,
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Vendor Qeydiyyatı',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Öz biznes hesabını yarat',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),

                // Name and Surname Row
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Ad',
                          prefixIcon: Icon(Icons.person_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: _validateName,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _surnameController,
                        decoration: InputDecoration(
                          labelText: 'Soyad',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: _validateSurname,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                // Shop Name
                TextFormField(
                  controller: _shopNameController,
                  decoration: InputDecoration(
                    labelText: 'Mağaza adı',
                    prefixIcon: Icon(Icons.store_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: _validateShopName,
                ),
                SizedBox(height: 20),

                // Shop Location
                TextFormField(
                  controller: _shopLocationController,
                  decoration: InputDecoration(
                    labelText: 'Mağaza ünvanı',
                    prefixIcon: Icon(Icons.location_on_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: _validateShopLocation,
                ),
                SizedBox(height: 20),
                //Email
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: _validateEmail,
                ),
                SizedBox(height: 20),

                // Mobile Number
                TextFormField(
                  controller: _mobileController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: 'Telefon nömrəsi',
                    prefixIcon: Icon(Icons.phone_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: _validateMobile,
                ),
                SizedBox(height: 20),

                // Password
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Şifrə',
                    prefixIcon: Icon(Icons.lock_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(
                        !_obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: _validatePassword,
                ),

                SizedBox(height: 30),

                // Sign Up Button
                ElevatedButton(
                  onPressed: _submitForm,

                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainBlue,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Qeydiyyatı tamamlayın',
                    style: TextStyle(fontSize: 16,color: Colors.white),
                  ),
                ),
                SizedBox(height: 20),

                // Already have an account
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Artıq qeydiyyatınız var?'),
                    TextButton(
                      onPressed: () {
                        context.push('/signIn');
                      },
                      child: Text('Giriş edin'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}