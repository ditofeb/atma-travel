import 'dart:convert';

class User {
  int? id;
  String? username;
  String? email;
  String? password;
  String? nomorTelp;
  String? imageUrl;

  User({
    this.id,
    this.username,
    this.email,
    this.password,
    this.nomorTelp,
    this.imageUrl,
  });

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        username: json["username"],
        email: json["email"],
        password: json["password"],
        nomorTelp: json["nomor_telp"],
        imageUrl: json["image_url"],
      );

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        "username": username,
        "email": email,
        "password": password,
        "nomor_telp": nomorTelp,
      };
}

List<User> customers = [
  User(
    username: 'Sandal terbang',
    email: 'ayam@gmail.com',
    password: '12345678',
    nomorTelp: '081234567890',
  ),
  User(
    username: 'Sendal nyangkut',
    email: 'sandal@gmail.com',
    password: 'password123',
    nomorTelp: '081987654321',
  ),
  User(
    username: 'Sendal berenang',
    email: 'sendal@example.com',
    password: 'sendal',
    nomorTelp: '081245678910',
  ),
];
