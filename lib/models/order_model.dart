class OrderModel {
  final int id;
  final String title;
  final DateTime orderDate;
  final int status;
  final double price;
  final int quantity;
  final String color;
  final String image;

  const OrderModel({
    required this.id,
    required this.title,
    required this.orderDate,
    required this.status,
    required this.price,
    required this.quantity,
    required this.color,
    required this.image,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      title: json['title'],
      orderDate: DateTime.parse(json['order_date']),
      status: json['status'],
      price: json['price'].toDouble(),
      quantity: json['quantity'],
      color: json['color'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'order_date': orderDate.toIso8601String(),
      'status': status,
      'price': price,
      'quantity': quantity,
      'color': color,
      'image': image,
    };
  }
}
