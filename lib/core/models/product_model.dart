// product_model.dart
class ProductModel {
  final int id;
  final String title;
  final double price;
  final String description;
  final String image;
  final String category; // Добавляем поле category

  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.image,
    required this.category, // Обновленный конструктор
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      title: json['title'],
      price: json['price'].toDouble(),
      description: json['description'],
      image: json['image'],
      category: json['category'], // Добавляем инициализацию поля category
    );
  }
}
