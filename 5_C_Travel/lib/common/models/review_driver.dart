import 'dart:convert';

class ReviewDriver {
  int? id;
  int? idDriver;
  int? idPemesanan;
  int? rating;
  String? komentar;
  String? username;

  ReviewDriver(
      {this.id,
      this.idDriver,
      this.idPemesanan,
      this.rating,
      this.komentar,
      this.username});

  factory ReviewDriver.fromRawJson(String str) =>
      ReviewDriver.fromJson(json.decode(str));

  factory ReviewDriver.fromJson(Map<String, dynamic> json) => ReviewDriver(
      id: json["id"],
      idPemesanan: json["id_pemesanan"],
      rating: json["rating"],
      komentar: json["komentar"],
      username: json["username"]);

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        "id_driver": idDriver,
        "id_pemesanan": idPemesanan,
        "rating": rating,
        "komentar": komentar,
      };
}
