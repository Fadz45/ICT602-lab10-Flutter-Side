// food_model.dart

class Food {
  final int id;
  final String name;
  final String description;
  final double price;

  Food({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'] is String ? double.tryParse(json['price']) ?? 0.0 : json['price'],
    );
  }
}
