class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? avatar;
  final String? address;
  final String? token;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.avatar,
    this.address,
    this.token,
  });

  // JSON থেকে Object তৈরি
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      avatar: json['avatar'],
      address: json['address'],
      token: json['token'] ?? json['access_token'],
    );
  }

  // Object থেকে JSON তৈরি
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avatar': avatar,
      'address': address,
      'token': token,
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
    String? token,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      address: address ?? this.address,
      token: token ?? this.token,
    );
  }
}