import 'dart:convert';

class ReviewKendaraan {
  int? id;
  int? idKendaraan;
  int? idPemesanan;
  int? rating;
  String? komentar;
  String? username;

  ReviewKendaraan(
      {this.id,
      this.idKendaraan,
      this.idPemesanan,
      this.rating,
      this.komentar,
      this.username});

  factory ReviewKendaraan.fromRawJson(String str) =>
      ReviewKendaraan.fromJson(json.decode(str));

  factory ReviewKendaraan.fromJson(Map<String, dynamic> json) =>
      ReviewKendaraan(
          id: json["id"],
          idPemesanan: json["id_pemesanan"],
          rating: json["rating"],
          komentar: json["komentar"],
          username: json["username"]);

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        "id_kendaraan": idKendaraan,
        "id_pemesanan": idPemesanan,
        "rating": rating,
        "komentar": komentar,
      };
}
