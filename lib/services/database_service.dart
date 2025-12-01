import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';

class DatabaseService {
  static const String _productsKey = 'products';
  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> addProduct(Product product) async {
    final products = await getAllProducts();
    products.add(product);
    await _saveProducts(products);
  }

  Future<void> updateProduct(Product product) async {
    final products = await getAllProducts();
    final index = products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      products[index] = product;
      await _saveProducts(products);
    }
  }

  Future<void> deleteProduct(String id) async {
    final products = await getAllProducts();
    products.removeWhere((p) => p.id == id);
    await _saveProducts(products);
  }

  Future<List<Product>> getAllProducts() async {
    final jsonString = _prefs.getString(_productsKey);
    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }
    try {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      print('Error loading products: $e');
      return [];
    }
  }

  Future<void> _saveProducts(List<Product> products) async {
    final jsonString = jsonEncode(
      products.map((p) => p.toJson()).toList(),
    );
    await _prefs.setString(_productsKey, jsonString);
  }

  Future<void> clearAllProducts() async {
    await _prefs.remove(_productsKey);
  }
}
