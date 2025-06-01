import 'dart:convert';

class Kendaraan {
  int? id;
  String? jenis;
  String? picture;
  String? plat;
  int? kapasitas;
  double? totalRating;
  List<double>? ratingBulanan;

  Kendaraan({
    this.id,
    this.jenis,
    this.picture,
    this.plat,
    this.kapasitas,
    this.totalRating,
    this.ratingBulanan,
  });

  factory Kendaraan.fromRawJson(String str) =>
      Kendaraan.fromJson(json.decode(str));

  factory Kendaraan.fromJson(Map<String, dynamic> json) {
    String? picture = jenisKendaraanMap[json["jenis_kendaraan"]];

    return Kendaraan(
      id: json["id"],
      jenis: json["jenis_kendaraan"],
      plat: json["nomor_plat"],
      totalRating: json["total_rating"] is int
          ? (json["total_rating"] as int).toDouble()
          : (json["total_rating"] as double?),
      kapasitas: json["kapasitas"],
      picture: picture,
      ratingBulanan: json['monthly_rating'] != null
          ? List<double>.from(json['monthly_rating'].map((x) => x.toDouble()))
          : [],
    );
  }

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        "jenis_kendaraan": jenis,
        "nomor_plat": plat,
        "kapasitas": kapasitas,
        "total_rating": totalRating?.toStringAsFixed(1),
      };
}

final Map<String, String> jenisKendaraanMap = {
  'Toyota HiAce': 'assets/images/hiace.png',
  'Isuzu Elf': 'assets/images/elf.png',
  'Nissan NV350': 'assets/images/urvan.jpg',
  'Mitsubishi Fuso': 'assets/images/fuso.png',
};

// final List<Kendaraan> mobil = List<Kendaraan>.from(
//   _mobil.map((e) => Kendaraan(e['jenis'] as String, e['picture'] as String, e['rating'] as String, e['plat'] as String, e['kapasitas'] as String))
// );

// final List<Map<String, Object>> _mobil = [
//   {
//     "jenis" : "New Hiace Commuter",
//     "picture" : "https://toyotacar.id/wp-content/uploads/2023/05/new-hiace-commuter.jpg",
//     "rating" : "4.8",
//     "plat" : "AB 1873 S",
//     "kapasitas" : "14",
//   },
//   {
//     "jenis" : "Isuzu Elf",
//     "picture" : "https://isuzujakarta.net/wp-content/uploads/isuzu-elf-microbus-1-2-1.jpg",
//     "rating" : "4.9",
//     "plat" : "AB 3323 DL",
//     "kapasitas" : "14",
//   },
//   {
//     "jenis" : "Mitsubishi Fuso",
//     "picture" : "https://www.sunmotor.com/wp-content/uploads/2020/07/FE-71-BC-Canter.jpg",
//     "rating" : "4.8",
//     "plat" : "AB 2561 SF",
//     "kapasitas" : "14",
//   },
//   {
//     "jenis" : "New Hiace Commuter",
//     "picture" : "https://www.sabirtoyota.com/wp-content/uploads/2022/02/1_beige-metallic-300x300.png",
//     "rating" : "4.7",
//     "plat" : "AB 9483 PB",
//     "kapasitas" : "14",
//   },
//   {
//     "jenis" : "Mitsubishi Fuso",
//     "picture" : "https://www.sunmotor.com/wp-content/uploads/2020/07/FE-71-BCCanter.jpg",
//     "rating" : "4.6",
//     "plat" : "AB 7538 DS",
//     "kapasitas" : "14",
//   }
// ];

// final List<Kendaraan> kendaraann = _mobil.map((e) => Kendaraan(
//   e['jenis'] as String,
//   e['picture'] as String,
//   e['rating'] as String,
//   e['plat'] as String,
//   e['kapasitas'] as String
// )).toList(growable: false);
