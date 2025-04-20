import 'package:flutter/material.dart';

import '../bloc_management/product_bloc/product_bloc.dart';



class ProductPreviewPage extends StatelessWidget {
  final Product product;

  const ProductPreviewPage({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Preview'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Edit functionality would go here
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Images Carousel
              _buildImageCarousel(),
              const SizedBox(height: 20),

              // Product Name and Category
              Text(
                product.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Chip(
                label: Text(
                  product.category,
                  style: const TextStyle(fontSize: 14),
                ),
                backgroundColor: Colors.grey[200],
              ),
              const SizedBox(height: 16),

              // Product Description
              const Text(
                'Description',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                product.description,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),

              // Size Options
              _buildSizeOptions(context),
              const SizedBox(height: 20),

              // Color Options
              _buildColorOptions(context),
              const SizedBox(height: 20),

              // Product ID
              Text(
                'Product ID: ${product.productId}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageCarousel() {
    return SizedBox(
      height: 250,
      child: PageView.builder(
        itemCount: product.images.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                product.images[index],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.broken_image, size: 50),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSizeOptions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Available Sizes',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: product.sizeOptions.map((sizeOption) {
            return Chip(
              label: Text(
                '${sizeOption['size']} - \$${sizeOption['price']}',
                style: TextStyle(
                  fontSize: 14,
                  color: sizeOption['isAvailable'] ? Colors.green[800] : Colors.red[800],
                ),
              ),
              backgroundColor: sizeOption['isAvailable']
                  ? Colors.green[100]
                  : Colors.red[100],
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildColorOptions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Available Colors',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: product.colorOptions.map((colorOption) {
            return Chip(
              label: Text(
                colorOption['color'],
                style: TextStyle(
                  fontSize: 14,
                  color: colorOption['isAvailable'] ? Colors.green[800] : Colors.red[800],
                ),
              ),
              backgroundColor: colorOption['isAvailable']
                  ? Colors.blue[100]
                  : Colors.red[100],
            );
          }).toList(),
        ),
      ],
    );
  }
}
