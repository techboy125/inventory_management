// Wear categories and subcategories
class WearCategory {
  final String name;
  final List<String> subcategories;

  WearCategory({required this.name, required this.subcategories});
}

final List<WearCategory> wearCategories = [
  WearCategory(
    name: 'Sarees',
    subcategories: ['Cotton Saree', 'Silk Saree', 'Georgette Saree', 'Linen Saree', 'Banarasi Saree', 'Chiffon Saree'],
  ),
  WearCategory(
    name: 'Top Wear',
    subcategories: ['Kurti', 'Shirt', 'Top', 'T-Shirt', 'Crop Top', 'Blouse'],
  ),
  WearCategory(
    name: 'Bottom Wear',
    subcategories: ['Pants', 'Jeans', 'Skirt', 'Leggings', 'Shorts', 'Palazzo'],
  ),
  WearCategory(
    name: 'Kurtas',
    subcategories: ['Cotton Kurta', 'Silk Kurta', 'Embroidered Kurta', 'Straight Kurta', 'A-Line Kurta'],
  ),
  WearCategory(
    name: 'Blouse',
    subcategories: ['Cotton Blouse', 'Silk Blouse', 'Designer Blouse', 'Embroidered Blouse'],
  ),
  WearCategory(
    name: 'Peticoat',
    subcategories: ['Cotton Peticoat', 'Silk Peticoat', 'Jacquard Peticoat'],
  ),
  WearCategory(
    name: 'Ethnic Wear',
    subcategories: ['Lehenga', 'Ghagra', 'Anarkali', 'Sharara', 'Salwar Kameez'],
  ),
  WearCategory(
    name: 'Accessories',
    subcategories: ['Scarf', 'Dupatta', 'Shawl', 'Belt', 'Jewelry'],
  ),
];

class Product {
  final String id;
  final String? imagePath;
  final String name;
  final String category;
  final String subcategory;
  final String material;
  final String size;
  final String color;
  final double buyingPrice;
  final double sellingPrice;
  final DateTime createdAt;

  Product({
    required this.id,
    this.imagePath,
    required this.name,
    required this.category,
    required this.subcategory,
    required this.material,
    required this.size,
    required this.color,
    required this.buyingPrice,
    required this.sellingPrice,
    required this.createdAt,
  });

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imagePath': imagePath,
      'name': name,
      'category': category,
      'subcategory': subcategory,
      'material': material,
      'size': size,
      'color': color,
      'buyingPrice': buyingPrice,
      'sellingPrice': sellingPrice,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Create from JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      imagePath: json['imagePath'],
      name: json['name'],
      category: json['category'] ?? 'Sarees',
      subcategory: json['subcategory'] ?? 'Cotton Saree',
      material: json['material'],
      size: json['size'],
      color: json['color'],
      buyingPrice: (json['buyingPrice'] as num).toDouble(),
      sellingPrice: (json['sellingPrice'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  // Copy with method for updates
  Product copyWith({
    String? id,
    String? imagePath,
    String? name,
    String? category,
    String? subcategory,
    String? material,
    String? size,
    String? color,
    double? buyingPrice,
    double? sellingPrice,
    DateTime? createdAt,
  }) {
    return Product(
      id: id ?? this.id,
      imagePath: imagePath ?? this.imagePath,
      name: name ?? this.name,
      category: category ?? this.category,
      subcategory: subcategory ?? this.subcategory,
      material: material ?? this.material,
      size: size ?? this.size,
      color: color ?? this.color,
      buyingPrice: buyingPrice ?? this.buyingPrice,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  double get profit => sellingPrice - buyingPrice;
  double get profitMargin => (profit / buyingPrice) * 100;
}
