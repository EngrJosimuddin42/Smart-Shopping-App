import 'cart_item_model.dart';
class Order {
  final String id;
  final List<CartItem> items;
  final double totalAmount;
  final String status;
  final DateTime createdAt;
  final String? deliveryAddress;

  Order({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
    this.deliveryAddress,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id']?.toString() ?? '',
      items: (json['items'] as List?)
          ?.map((item) => CartItem.fromJson(item))
          .toList() ?? [],
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      status: json['status'] ?? 'pending',
      createdAt: DateTime.parse(json['createdAt']),
      deliveryAddress: json['deliveryAddress'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((item) => item.toJson()).toList(),
      'totalAmount': totalAmount,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'deliveryAddress': deliveryAddress,
    };
  }
}