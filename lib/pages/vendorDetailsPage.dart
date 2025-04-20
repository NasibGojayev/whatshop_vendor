import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';

class VendorDetailsPage extends StatefulWidget {

  VendorDetailsPage({super.key});

  @override
  _VendorDetailsPageState createState() => _VendorDetailsPageState();
}

class _VendorDetailsPageState extends State<VendorDetailsPage> {
  String vendorId = "@orucomarov468";
  final _formKey = GlobalKey<FormState>();
  final _supabase = Supabase.instance.client;
  final ImagePicker _imagePicker = ImagePicker();

  bool _isLoading = true;
  bool _isSaving = false;
  File? _avatarImageFile;
  File? _shopImageFile;

  // Form fields
   String _name = 'Oruc Omarov';
   String _email = 'oruc@gmail.com';
   String _phone = '0500515253';
   String _address = 'baku qax';
   String _description= ' no description yet';
   String _shopName = 'WhatShop';
  String? _avatarPicUrl;
  String? _shopImageUrl;

  @override
  void initState() {
    super.initState();
  }


  Future<void> _pickImage(bool isAvatar) async {
    try {
      final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          if (isAvatar) {
            _avatarImageFile = File(pickedFile.path);
          } else {
            _shopImageFile = File(pickedFile.path);
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: ${e.toString()}')),
      );
    }
  }

  Future<String?> _uploadImage(File? imageFile, String currentUrl) async {
    if (imageFile == null) return currentUrl;

    final fileExt = imageFile.path.split('.').last;
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExt';
    final filePath = 'vendor_images/$vendorId/$fileName';

    try {
      await _supabase.storage
          .from('vendor-images')
          .upload(filePath, imageFile);

      return _supabase.storage
          .from('vendor-images')
          .getPublicUrl(filePath);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading image: ${e.toString()}')),
      );
      return null;
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      // Upload images if changed
      final newAvatarUrl = await _uploadImage(_avatarImageFile, _avatarPicUrl ?? '');
      final newShopImageUrl = await _uploadImage(_shopImageFile, _shopImageUrl ?? '');

      // Update profile data
      /*await _supabase.from('vendors').upsert({
        'vendor_id': vendorId,
        'name': _name,
        'email': _email,
        'phone': _phone,
        'address': _address,
        'description': _description,
        'shop_name': _shopName,
        'avatar_pic': newAvatarUrl ?? _avatarPicUrl,
        'shop_image': newShopImageUrl ?? _shopImageUrl,
      });*/

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving profile: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Widget _buildImagePicker(String title, String? imageUrl, File? imageFile, bool isAvatar) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _pickImage(isAvatar),
          child: Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[400]!),
            ),
            child: imageFile != null
                ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(imageFile, fit: BoxFit.cover),
            )
                : (imageUrl != null && imageUrl.isNotEmpty)
                ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(imageUrl, fit: BoxFit.cover),
            )
                : const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_a_photo, size: 40),
                  Text('Tap to add photo'),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _isSaving ? null : _saveProfile,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImagePicker('Profile Picture', _avatarPicUrl, _avatarImageFile, true),
              _buildImagePicker('Shop Image', _shopImageUrl, _shopImageFile, false),

              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                onSaved: (value) => _name = value!,
              ),
              const SizedBox(height: 16),

              TextFormField(
                initialValue: _email,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
                onSaved: (value) => _email = value!,
              ),
              const SizedBox(height: 16),

              TextFormField(
                initialValue: _phone,
                decoration: const InputDecoration(labelText: 'Phone'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
                onSaved: (value) => _phone = value!,
              ),
              const SizedBox(height: 16),

              TextFormField(
                initialValue: _address,
                decoration: const InputDecoration(labelText: 'Address'),
                maxLines: 2,
                onSaved: (value) => _address = value!,
              ),
              const SizedBox(height: 16),

              TextFormField(
                initialValue: _shopName,
                decoration: const InputDecoration(labelText: 'Shop Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your shop name';
                  }
                  return null;
                },
                onSaved: (value) => _shopName = value!,
              ),
              const SizedBox(height: 16),

              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                onSaved: (value) => _description = value!,
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      _saveProfile();
                    }
                  },
                  child: _isSaving
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Save Profile'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}