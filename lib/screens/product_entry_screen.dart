import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/product.dart';
import '../services/database_service.dart';

class ProductEntryScreen extends StatefulWidget {
  final DatabaseService databaseService;
  final Product? product;

  const ProductEntryScreen({
    super.key,
    required this.databaseService,
    this.product,
  });

  @override
  State<ProductEntryScreen> createState() => _ProductEntryScreenState();
}

class _ProductEntryScreenState extends State<ProductEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _materialController;
  late TextEditingController _sizeController;
  late TextEditingController _colorController;
  late TextEditingController _buyingPriceController;
  late TextEditingController _sellingPriceController;

  String? _imagePath;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product?.name ?? '');
    _materialController =
        TextEditingController(text: widget.product?.material ?? '');
    _sizeController = TextEditingController(text: widget.product?.size ?? '');
    _colorController = TextEditingController(text: widget.product?.color ?? '');
    _buyingPriceController = TextEditingController(
      text: widget.product?.buyingPrice.toString() ?? '',
    );
    _sellingPriceController = TextEditingController(
      text: widget.product?.sellingPrice.toString() ?? '',
    );
    _imagePath = widget.product?.imagePath;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _materialController.dispose();
    _sizeController.dispose();
    _colorController.dispose();
    _buyingPriceController.dispose();
    _sellingPriceController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    try {
      final pickedFile = await showDialog<ImageSource>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Select Image Source'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, ImageSource.camera),
              child: const Text('Camera'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, ImageSource.gallery),
              child: const Text('Gallery'),
            ),
          ],
        ),
      );

      if (pickedFile == null) return;

      final image = await picker.pickImage(source: pickedFile);
      if (image != null) {
        setState(() {
          _imagePath = image.path;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;
    if (_imagePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final product = Product(
        id: widget.product?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        imagePath: _imagePath,
        name: _nameController.text.trim(),
        material: _materialController.text.trim(),
        size: _sizeController.text.trim(),
        color: _colorController.text.trim(),
        buyingPrice: double.parse(_buyingPriceController.text.trim()),
        sellingPrice: double.parse(_sellingPriceController.text.trim()),
        createdAt: widget.product?.createdAt ?? DateTime.now(),
      );

      if (widget.product != null) {
        await widget.databaseService.updateProduct(product);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product updated successfully')),
        );
      } else {
        await widget.databaseService.addProduct(product);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product added successfully')),
        );
      }

      Navigator.pop(context, product);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving product: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product != null ? 'Edit Product' : 'Add New Product'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Section
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 250,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[100],
                  ),
                  child: _imagePath != null
                      ? Image.file(
                          File(_imagePath!),
                          fit: BoxFit.cover,
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.camera_alt,
                              size: 50,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tap to capture/select image',
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 24),

              // Product Details Section
              Text(
                'Product Details',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),

              // Name
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Product Name *',
                  hintText: 'Enter product name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.tag),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Product name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Material
              TextFormField(
                controller: _materialController,
                decoration: InputDecoration(
                  labelText: 'Material *',
                  hintText: 'e.g., Cotton, Plastic, Steel',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.library_books),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Material is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Size
              TextFormField(
                controller: _sizeController,
                decoration: InputDecoration(
                  labelText: 'Size *',
                  hintText: 'e.g., S, M, L, XL, 10cm, 5inch',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.straighten),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Size is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Color
              TextFormField(
                controller: _colorController,
                decoration: InputDecoration(
                  labelText: 'Color *',
                  hintText: 'e.g., Red, Blue, Black',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.palette),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Color is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Pricing Section
              Text(
                'Pricing (in INR)',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),

              // Buying Price
              TextFormField(
                controller: _buyingPriceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Buying Price (₹) *',
                  hintText: '0.00',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.shopping_bag),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Buying price is required';
                  }
                  try {
                    double.parse(value.trim());
                  } catch (e) {
                    return 'Enter a valid price';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Selling Price
              TextFormField(
                controller: _sellingPriceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Selling Price (₹) *',
                  hintText: '0.00',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.shopping_cart),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Selling price is required';
                  }
                  try {
                    double.parse(value.trim());
                  } catch (e) {
                    return 'Enter a valid price';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Profit Display (if both prices are entered)
              if (_buyingPriceController.text.isNotEmpty &&
                  _sellingPriceController.text.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Profit per unit:',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Text(
                        '₹${(double.parse(_sellingPriceController.text) - double.parse(_buyingPriceController.text)).toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.green[700],
                            ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 24),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveProduct,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Save Product',
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
