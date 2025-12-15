class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? avatar;
  final String? address;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.avatar,
    this.address,
  });

  // JSON থেকে Object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      avatar: json['avatar'],
      address: json['address'],
    );
  }

  // Object থেকে JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avatar': avatar,
      'address': address,
    };
  }

  // CopyWith method
  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? avatar,
    String? address,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      address: address ?? this.address,
    );
  }
}