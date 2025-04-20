import 'package:flutter/material.dart';

import '../bloc_management/product_bloc/product_bloc.dart';



class EditProductPage extends StatefulWidget {
  final Product product;

  const EditProductPage({super.key, required this.product});

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _categoryController;
  late List<Map<String, dynamic>> _sizeOptions;
  late List<Map<String, dynamic>> _colorOptions;
  late List<String> _images;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.name);
    _descriptionController = TextEditingController(text: widget.product.description);
    _categoryController = TextEditingController(text: widget.product.category);
    _sizeOptions = List.from(widget.product.sizeOptions);
    _colorOptions = List.from(widget.product.colorOptions);
    _images = List.from(widget.product.images);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveChanges,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBasicInfoSection(),
            const SizedBox(height: 24),
            _buildSizeOptionsSection(),
            const SizedBox(height: 24),
            _buildColorOptionsSection(),
            const SizedBox(height: 24),
            _buildImagesSection(),
            const SizedBox(height: 32),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Basic Information',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Product Name',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _descriptionController,
          decoration: const InputDecoration(
            labelText: 'Description',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _categoryController,
          decoration: const InputDecoration(
            labelText: 'Category',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildSizeOptionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Size Options',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ..._sizeOptions.map((sizeOption) {
          final index = _sizeOptions.indexOf(sizeOption);
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: TextEditingController(text: sizeOption['size']),
                    decoration: const InputDecoration(
                      labelText: 'Size',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _sizeOptions[index]['size'] = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: TextEditingController(
                        text: sizeOption['price'].toString()),
                    decoration: const InputDecoration(
                      labelText: 'Price',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        _sizeOptions[index]['price'] = double.tryParse(value) ?? 0;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Switch(
                  value: sizeOption['isAvailable'] ?? false,
                  onChanged: (value) {
                    setState(() {
                      _sizeOptions[index]['isAvailable'] = value;
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      _sizeOptions.removeAt(index);
                    });
                  },
                ),
              ],
            ),
          );
        }).toList(),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _sizeOptions.add({
                'size': '',
                'price': 0.0,
                'isAvailable': true,
              });
            });
          },
          child: const Text('Add Size Option'),
        ),
      ],
    );
  }

  Widget _buildColorOptionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Color Options',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ..._colorOptions.map((colorOption) {
          final index = _colorOptions.indexOf(colorOption);
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: TextEditingController(text: colorOption['color']),
                    decoration: const InputDecoration(
                      labelText: 'Color',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _colorOptions[index]['color'] = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Switch(
                  value: colorOption['isAvailable'] ?? false,
                  onChanged: (value) {
                    setState(() {
                      _colorOptions[index]['isAvailable'] = value;
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      _colorOptions.removeAt(index);
                    });
                  },
                ),
              ],
            ),
          );
        }).toList(),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _colorOptions.add({
                'color': '',
                'isAvailable': true,
              });
            });
          },
          child: const Text('Add Color Option'),
        ),
      ],
    );
  }

  Widget _buildImagesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Product Images',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _images.map((imageUrl) {
            return Stack(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _images.remove(imageUrl);
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            // In a real app, this would open an image picker
            setState(() {
              _images.add('https://via.placeholder.com/150');
            });
          },
          child: const Text('Add Image'),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        ),
        onPressed: _saveChanges,
        child: const Text('Save Changes', style: TextStyle(fontSize: 18)),
      ),
    );
  }

  void _saveChanges() {
    final updatedProduct = Product(
      name: _nameController.text,
      description: _descriptionController.text,
      sizeOptions: _sizeOptions,
      colorOptions: _colorOptions,
      images: _images,
      category: _categoryController.text,
      productId: widget.product.productId,
      isActive: widget.product.isActive ,
      avgRating: widget.product.avgRating,
    );

    // Print the updated product to console
    print('Updated Product:');
    print('Name: ${updatedProduct.name}');
    print('Description: ${updatedProduct.description}');
    print('Category: ${updatedProduct.category}');
    print('Size Options: ${updatedProduct.sizeOptions}');
    print('Color Options: ${updatedProduct.colorOptions}');
    print('Images: ${updatedProduct.images}');
    print('Product ID: ${updatedProduct.productId}');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Changes saved (printed to console)')),
    );
  }
}

// Example usage:
// Navigator.push(context, MaterialPageRoute(builder: (context) => EditProductPage(
//   product: Product(
//     name: "Sample Product",
//     description: "This is a sample product description",
//     sizeOptions: [
//       {"size": "S", "price": 29.99, "isAvailable": true},
//       {"size": "M", "price": 34.99, "isAvailable": true},
//     ],
//     images: [
//       "https://via.placeholder.com/150",
//       "https://via.placeholder.com/150",
//     ],
//     colorOptions: [
//       {"color": "Red", "isAvailable": true},
//       {"color": "Blue", "isAvailable": false},
//     ],
//     category: "Clothing",
//     productId: "12345",
//   ),
// ));