import 'dart:convert';

class Driver {
  int? id;
  String? nama;
  DateTime? tanggalLahir;
  String? nomorTelp;
  double? totalRating;
  List<double>? ratingBulanan;

  Driver({
    this.id,
    this.nama,
    this.tanggalLahir,
    this.nomorTelp,
    this.totalRating,
    this.ratingBulanan,
  });

  factory Driver.fromRawJson(String str) => Driver.fromJson(json.decode(str));

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
        id: json["id"],
        nama: json["nama"],
        tanggalLahir: json["tanggal_lahir"] != null
            ? DateTime.parse(json["tanggal_lahir"])
            : null,
        nomorTelp: json["nomor_telepon"],
        totalRating: json["total_rating"] is int
            ? (json["total_rating"] as int).toDouble()
            : (json["total_rating"] as double?),
        ratingBulanan: json['monthly_rating'] != null
            ? List<double>.from(json['monthly_rating'].map((x) => x.toDouble()))
            : [],
      );

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        "nama": nama,
        "tanggal_lahir": tanggalLahir?.toIso8601String(),
        "nomor_telepon": nomorTelp,
        "total_rating": totalRating?.toStringAsFixed(1),
      };
}

// final List<Driver> people = _people
//     .map((e) => Driver(
//           e['id'] as String,
//           e['name'] as String,
//           e['phone'] as String,
//           e['picture'] as String,
//           e['age'] as String,
//           e['rating'] as String,
//           e['birth'] as String,
//         ))
//     .toList(growable: false);

// final List<Map<String, Object>> _people = [
//   {
//     "name": "Sandal",
//     "phone": "+62 987-548-3165",
//     "picture":
//         "https://i.pinimg.com/564x/71/1f/c0/711fc0f41b1316c2d8d265b4bbec1880.jpg",
//     "age": "30",
//     "rating": "4.5",
//     "birth": "1994-08-15",
//   },
//   {
//     "name": "Nyangkut",
//     "phone": "+62 892-586-3072",
//     "picture":
//         "https://i.pinimg.com/564x/b4/84/1c/b4841c4d01a8495b976531a55b5b615c.jpg",
//     "age": "34",
//     "rating": "4.8",
//     "birth": "1990-02-22",
//   },
//   {
//     "name": "Di Pohon",
//     "phone": "+62 927-536-3003",
//     "picture":
//         "https://i.pinimg.com/564x/fe/ea/cd/feeacd0aa22bd3aface7d7ba11c01364.jpg",
//     "rating": "4.3",
//     "age": "28",
//     "birth": "1996-05-09",
//   }
// ];
