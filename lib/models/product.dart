class Product {
  final String id;
  final String? imagePath;
  final String name;
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
