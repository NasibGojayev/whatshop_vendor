import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatshop_vendor/tools/colors.dart';

import '../bloc_management/product_bloc/product_bloc.dart';
import '../bloc_management/product_bloc/product_event.dart';

class AddProductFlow extends StatefulWidget {
  const AddProductFlow({super.key});

  @override
  State<AddProductFlow> createState() => _AddProductFlowState();
}

class _AddProductFlowState extends State<AddProductFlow> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentStep = 0;

  // Product data state
  String productName = '';
  String productDescription = '';
  List<XFile> productImages = [];
  String selectedCategory = '';
  List<Map<String, dynamic>> sizeVariants = []; // Updated structure
  List<String> colors = [];
  List<String> allSizes = [
    'XS', 'S', 'M', 'L', 'XL', 'XXL', 'XXXL',
    '32', '34', '36', '37', '38', '39', '40', '41', '42', '43', '44', '45',
  ];
  List<String> categories = ['Clothing', 'Accessories', 'Shoes', 'Electronics', 'Home Goods'];

  void _nextStep() {
    if (_currentStep < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep++);
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep--);
    }
  }

  bool _validateStep1() {
    return productName.isNotEmpty &&
        productDescription.isNotEmpty &&
        productImages.isNotEmpty;
  }

  bool _validateStep2() {
    return selectedCategory.isNotEmpty &&
        sizeVariants.isNotEmpty &&
        sizeVariants.every((variant) => variant['price'] > 0);
  }

  void _submitProduct() {
    // This will be handled by you in the backend

    context.read<ProductBloc>().add(
      AddProductEvent(
        name: productName,
        description: productDescription,
        sizeOptions: sizeVariants,
        images: productImages,
        colorOptions: colors.map((e)=>{
          'color': e,
          'isAvailable': true
        }).toList(),
        category: selectedCategory,
        productId: '',
      ),
    );


    // Show loading state
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    // Simulate submission delay
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context); // Remove loading dialog
      // Show success dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Əla!'),
          content: const Text('Məhsul Uğurla Əlavə Olundu'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close success dialog
                Navigator.pop(context); // Close the entire flow
              },
              child: const Text('Tamam'),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yeni Məhsul Əlavə Et'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Step indicator
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(3, (index) {
                return Column(
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentStep >= index
                            ? Theme.of(context).primaryColor
                            : Colors.grey[300],
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: _currentStep >= index
                                ? Colors.white
                                : Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      ['Detallar', 'Seçimlər', 'Baxış'][index],
                      style: TextStyle(
                        color: _currentStep >= index
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
          const Divider(height: 1),

          // PageView for steps
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Step1ProductInfo(
                  productName: productName,
                  productDescription: productDescription,
                  productImages: productImages,
                  onChanged: (name, description, images) {
                    setState(() {
                      productName = name;
                      productDescription = description;
                      productImages = images;
                    });
                  },
                ),
                Step2Options(
                  categories: categories,
                  selectedCategory: selectedCategory,
                  allSizes: allSizes,
                  sizeVariants: sizeVariants,
                  colors: colors,
                  onChanged: (category, variants, colorList) {
                    setState(() {
                      selectedCategory = category;
                      sizeVariants = variants;
                      colors = colorList;
                    });
                  },
                ),
                Step3Overview(
                  productName: productName,
                  productDescription: productDescription,
                  productImages: productImages,
                  selectedCategory: selectedCategory,
                  sizeVariants: sizeVariants,
                  colors: colors,
                  onSubmit: _submitProduct,
                ),
              ],
            ),
          ),

          // Navigation buttons
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                if (_currentStep > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _previousStep,
                      child: const Text('Geri'),
                    ),
                  ),
                if (_currentStep > 0) const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mainBlue,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      if (_currentStep == 0 && !_validateStep1()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Zəhmət olmasa bütün xanaları doldurun və ən azı 1 şəkil əlavə edin')),
                        );
                        return;
                      }
                      if (_currentStep == 1 && !_validateStep2()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Kateqoriya , Rəng , ölçü və uyğun qiymətləri yazın')),
                        );
                        return;
                      }
                      if (_currentStep == 2) {
                        _submitProduct();
                      } else {
                        _nextStep();
                      }
                    },
                    child: Text(_currentStep == 2 ? 'Dərc Et' : 'İrəli'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Step1ProductInfo extends StatefulWidget {
  final String productName;
  final String productDescription;
  final List<XFile> productImages;
  final Function(String, String, List<XFile>) onChanged;

  const Step1ProductInfo({
    super.key,
    required this.productName,
    required this.productDescription,
    required this.productImages,
    required this.onChanged,
  });

  @override
  State<Step1ProductInfo> createState() => _Step1ProductInfoState();
}

class _Step1ProductInfoState extends State<Step1ProductInfo> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.productName;
    _descController.text = widget.productDescription;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage();
      if (images.isNotEmpty) {
        final newImages = [...widget.productImages, ...images];
        if (newImages.length > 5) {
          widget.onChanged(
            _nameController.text,
            _descController.text,
            newImages.sublist(0, 5),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Maksimum 5 şəkil əlavə ede bilərsiniz')),
          );
        } else {
          widget.onChanged(
            _nameController.text,
            _descController.text,
            newImages,
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Şəkilləri seçərkən xəta oldu: $e')),
      );
    }
  }

  void _removeImage(int index) {
    final newImages = List<XFile>.from(widget.productImages);
    newImages.removeAt(index);
    widget.onChanged(
      _nameController.text,
      _descController.text,
      newImages,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Məhsul Detalları',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Məhsul Adı',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) => widget.onChanged(
              value,
              _descController.text,
              widget.productImages,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _descController,
            decoration: const InputDecoration(
              labelText: 'Məhsul Haqqında',
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
            maxLines: 4,
            onChanged: (value) => widget.onChanged(
              _nameController.text,
              value,
              widget.productImages,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Məhsul Şəkilləri (1-5)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: _pickImage,
            icon: const Icon(Icons.add_photo_alternate),
            label: const Text('Şəkilləri Seç'),
          ),
          if (widget.productImages.isNotEmpty) ...[
            const SizedBox(height: 16),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.productImages.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Stack(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: FileImage(
                                File(widget.productImages[index].path),
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () => _removeImage(index),
                            child: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black54,
                              ),
                              child: const Icon(
                                Icons.close,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class Step2Options extends StatefulWidget {
  final List<String> categories;
  final String selectedCategory;
  final List<String> allSizes;
  final List<Map<String, dynamic>> sizeVariants;
  final List<String> colors;
  final Function(String, List<Map<String, dynamic>>, List<String>) onChanged;

  const Step2Options({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.allSizes,
    required this.sizeVariants,
    required this.colors,
    required this.onChanged,
  });

  @override
  State<Step2Options> createState() => _Step2OptionsState();
}

class _Step2OptionsState extends State<Step2Options> {
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _customSizeController = TextEditingController();
  final Map<String, TextEditingController> _sizePriceControllers = {};
  late List<String> _selectedColors;
  late List<Map<String, dynamic>> _sizeVariants;

  // Predefined list of common colors
  final List<String> _predefinedColors = [
    'Qara', 'Ağ', 'Qırmızı', 'Mavi', 'Yaşıl', 'Sarı',
    'Bənövşəyi', 'Çəhrayı', 'Narıncı', 'Boz', 'Qəhvəyi',
    'Bej'
  ];

  @override
  void initState() {
    super.initState();
    _selectedColors = List.from(widget.colors);
    _sizeVariants = List.from(widget.sizeVariants);

    // Initialize controllers for existing variants
    for (final variant in _sizeVariants) {
      _sizePriceControllers[variant['size']] = TextEditingController(
        text: variant['price'] > 0 ? variant['price'].toStringAsFixed(2) : '',
      );
    }
  }

  @override
  void dispose() {
    _colorController.dispose();
    _customSizeController.dispose();
    for (var controller in _sizePriceControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _showCategoryModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return _CategorySelectionModal(
          categories: widget.categories,
          selectedCategory: widget.selectedCategory,
          onCategorySelected: (category) {
            widget.onChanged(
              category,
              _sizeVariants,
              _selectedColors,
            );
            Navigator.pop(context);
          },
        );
      },
    );
  }

  void _addColor() {
    final color = _colorController.text.trim();
    if (color.isNotEmpty && !_selectedColors.contains(color)) {
      setState(() {
        _selectedColors.add(color);
        _colorController.clear();
      });
      _updateParent();
    }
  }

  void _removeColor(String color) {
    setState(() {
      _selectedColors.remove(color);
    });
    _updateParent();
  }

  void _addPredefinedColor(String color) {
    if (!_selectedColors.contains(color)) {
      setState(() {
        _selectedColors.add(color);
      });
      _updateParent();
    }
  }

  void _addCustomSize() {
    final size = _customSizeController.text.trim();
    if (size.isNotEmpty && !_sizeVariants.any((v) => v['size'] == size)) {
      setState(() {
        _sizeVariants.add({
          'size': size,
          'price': 0.0,
          'isAvailable': true,
        });
        _sizePriceControllers[size] = TextEditingController(text: '');
        _customSizeController.clear();
      });
      _updateParent();
    }
  }

  void _updateParent() {
    widget.onChanged(
      widget.selectedCategory,
      _sizeVariants,
      _selectedColors,
    );
  }

  void _updateSizePrice(String size, String value) {
    if (value.isEmpty) {
      setState(() {
        final index = _sizeVariants.indexWhere((v) => v['size'] == size);
        if (index != -1) {
          _sizeVariants[index]['price'] = 0.0;
        }
      });
      _updateParent();
      return;
    }

    final parsedPrice = double.tryParse(value);
    if (parsedPrice != null) {
      setState(() {
        final index = _sizeVariants.indexWhere((v) => v['size'] == size);
        if (index != -1) {
          _sizeVariants[index]['price'] = parsedPrice;
        }
      });
      _updateParent();
    }
  }

  void _removeSize(String size) {
    setState(() {
      _sizeVariants.removeWhere((v) => v['size'] == size);
      _sizePriceControllers[size]?.dispose();
      _sizePriceControllers.remove(size);
    });
    _updateParent();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Məhsul Seçimləri',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          // Replaced Dropdown with TextField that opens modal
          TextFormField(
            readOnly: true,
            controller: TextEditingController(text: widget.selectedCategory),
            decoration: const InputDecoration(
              labelText: 'Kateqoriya',
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.arrow_drop_down),
            ),
            onTap: _showCategoryModal,
          ),
          // Rest of your existing widget tree...
          const SizedBox(height: 24),
          const Text(
            'Ölçülər',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),

          const Text(
            'Standart Ölçülər:',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.allSizes.map((size) {
              final isSelected = _sizeVariants.any((v) => v['size'] == size);
              return FilterChip(
                label: Text(size),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _sizeVariants.add({
                        'size': size,
                        'price': 0.0,
                        'isAvailable': true,
                      });
                      _sizePriceControllers[size] = TextEditingController(text: '');
                    } else {
                      _sizeVariants.removeWhere((v) => v['size'] == size);
                      _sizePriceControllers[size]?.dispose();
                      _sizePriceControllers.remove(size);
                    }
                  });
                  _updateParent();
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 16),
          const Text(
            'Özəl Ölçü Əlavə Et (istəyə görə):',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _customSizeController,
                  decoration: const InputDecoration(
                    labelText: 'Ölçü Adı',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: _addCustomSize,
              ),
            ],
          ),

          if (_sizeVariants.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text(
              'Ölçülər və Qiymətlər:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            ..._sizeVariants.map((variant) {
              final size = variant['size'];
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 140,
                      child: Row(
                        children: [
                          Text(size),
                          IconButton(
                            icon: const Icon(Icons.close, size: 16),
                            onPressed: () => _removeSize(size),
                            padding: EdgeInsets.zero,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Qiymət',
                          prefixText: '₼',
                          border: const OutlineInputBorder(),
                          errorText: variant['price'] <= 0 ? 'Keçərli qiymət daxil edin' : null,
                        ),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                        ],
                        controller: _sizePriceControllers[size],
                        onChanged: (value) => _updateSizePrice(size, value),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],

          const SizedBox(height: 24),
          const Text(
            'Rənglər',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),

          // Predefined colors section
          const Text(
            'Standart Rənglər:',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _predefinedColors.map((color) {
              final isSelected = _selectedColors.contains(color);
              return FilterChip(
                label: Text(color),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    _addPredefinedColor(color);
                  } else {
                    _removeColor(color);
                  }
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 16),
          const Text(
            'Özəl Rəng Əlavə Et (istəyə görə):',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _colorController,
                  decoration: const InputDecoration(
                    labelText: 'Rəng Adı',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (_) => _addColor(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: _addColor,
              ),
            ],
          ),

          if (_selectedColors.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text(
              'Seçilmiş Rənglər:',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _selectedColors.map((color) {
                return Chip(
                  label: Text(color),
                  onDeleted: () => _removeColor(color),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class _CategorySelectionModal extends StatefulWidget {
  final List<String> categories;
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const _CategorySelectionModal({
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  State<_CategorySelectionModal> createState() => _CategorySelectionModalState();
}

class _CategorySelectionModalState extends State<_CategorySelectionModal> {
  late List<String> _filteredCategories;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredCategories = List.from(widget.categories);
    _searchController.addListener(_filterCategories);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterCategories() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredCategories = List.from(widget.categories);
      } else {
        _filteredCategories = widget.categories
            .where((category) => category.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height * 0.8,
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              labelText: 'Kateqoriya axtar',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            autofocus: true,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredCategories.length,
              itemBuilder: (context, index) {
                final category = _filteredCategories[index];
                return ListTile(
                  title: Text(category),
                  trailing: category == widget.selectedCategory
                      ? const Icon(Icons.check, color: Colors.green)
                      : null,
                  onTap: () => widget.onCategorySelected(category),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


class Step3Overview extends StatelessWidget {
  final String productName;
  final String productDescription;
  final List<XFile> productImages;
  final String selectedCategory;
  final List<Map<String, dynamic>> sizeVariants;
  final List<String> colors;
  final VoidCallback onSubmit;

  const Step3Overview({
    super.key,
    required this.productName,
    required this.productDescription,
    required this.productImages,
    required this.selectedCategory,
    required this.sizeVariants,
    required this.colors,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Baxış və Təsdiq',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          const Text(
            'Məhsul Məlumatları',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const Divider(),
          _buildInfoRow('Adı', productName),
          _buildInfoRow('Təsviri', productDescription),
          const SizedBox(height: 8),
          if (productImages.isNotEmpty) ...[
            const Text(
              'Şəkillər:',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: productImages.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: FileImage(File(productImages[index].path)),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
          const SizedBox(height: 16),
          const Text(
            'Seçimlər',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const Divider(),
          _buildInfoRow('Kateqoriya', selectedCategory),
          if (sizeVariants.isNotEmpty) ...[
            const SizedBox(height: 8),
            const Text(
              'Ölçülər və Qiymətlər:',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            ...sizeVariants.map((variant) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 50,
                      child: Text(variant['size']),
                    ),
                    Text('₼${variant['price'].toStringAsFixed(2)}'),
                  ],
                ),
              );
            }),
          ],
          if (colors.isNotEmpty) ...[
            const SizedBox(height: 8),
            const Text(
              'Rənglər:',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: colors.map((color) {
                return Chip(
                  label: Text(color),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}