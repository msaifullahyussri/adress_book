class ContactModel {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String avatar;
  final bool isFavorite;

  ContactModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.avatar,
    this.isFavorite = false,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) => ContactModel(
    id: json['id'].toString(),
    name: json['name'],
    phone: json['phone'],
    email: json['email'] ?? '',
    avatar: json['avatar'] ?? 'assets/images/user.png',
    isFavorite: json['isFavorite'] == 1 ? true : false,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'phone': phone,
    'email': email,
    'avatar': avatar,
    'isFavorite': isFavorite ? 1 : 0,
  };

  ContactModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? avatar,
    bool? isFavorite,
  }) {
    return ContactModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
