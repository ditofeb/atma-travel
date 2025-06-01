import 'dart:convert';

import 'package:tubes_5_c_travel/common/models/Driver.dart';
import 'package:tubes_5_c_travel/common/models/kendaraan.dart';

class Jadwal {
  int? id;
  int? idDriver;
  int? idKendaraan;
  String? titikKeberangkatan;
  String? titikKedatangan;
  DateTime? waktuKeberangkatan;
  DateTime? waktuKedatangan;
  double? harga;
  Driver? driver;
  Kendaraan? kendaraan;
  int? sisaVIP;
  int? sisaReguler;

  Jadwal({
    this.id,
    this.idDriver,
    this.idKendaraan,
    this.titikKeberangkatan,
    this.titikKedatangan,
    this.waktuKeberangkatan,
    this.waktuKedatangan,
    this.harga,
    this.driver,
    this.kendaraan,
    this.sisaVIP,
    this.sisaReguler,
  });

  factory Jadwal.fromRawJson(String str) => Jadwal.fromJson(json.decode(str));

  factory Jadwal.fromJson(Map<String, dynamic> json) => Jadwal(
        id: json["id"],
        idDriver: json["id_driver"],
        idKendaraan: json["id_kendaraan"],
        titikKeberangkatan: json["titik_keberangkatan"],
        titikKedatangan: json["titik_kedatangan"],
        waktuKeberangkatan: json["waktu_keberangkatan"] != null
            ? DateTime.parse(json["waktu_keberangkatan"])
            : null,
        waktuKedatangan: json["waktu_kedatangan"] != null
            ? DateTime.parse(json["waktu_kedatangan"])
            : null,
        harga: json["harga"] != null
            ? double.tryParse(json["harga"].toString())
            : null,
        driver: json['driver'] != null ? Driver.fromJson(json['driver']) : null,
        kendaraan: json['kendaraan'] != null
            ? Kendaraan.fromJson(json['kendaraan'])
            : null,
        sisaVIP: json['sisaVIP'],
        sisaReguler: json['sisaReguler'],
      );

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        "titik_keberangkatan": titikKeberangkatan,
        "titik_kedatangan": titikKedatangan,
        "waktu_keberangkatan": waktuKeberangkatan?.toIso8601String(),
        "waktu_kedatangan": waktuKedatangan?.toIso8601String(),
        "id_driver": idDriver,
        "id_kendaraan": idKendaraan,
        "harga": harga!.toStringAsFixed(0),
      };
}

const Map<String, String> listKota = {
  'Jakarta': 'JKT',
  'Semarang': 'SMG',
  'Solo': 'SLO',
  'Salatiga': 'STA',
  'Bandung': 'BDG',
  'Surabaya': 'SBY',
  'Yogyakarta': 'YOG',
  'Bogor': 'BOG',
  'Tangerang': 'TGR',
};

const Map<String, Map<String, double>> koordinatKota = {
  'Jakarta': {'lat': -6.2088, 'long': 106.8456},
  'Semarang': {'lat': -7.0052, 'long': 110.4381},
  'Solo': {'lat': -7.5665, 'long': 110.8254},
  'Salatiga': {'lat': -7.3319, 'long': 110.5062},
  'Bandung': {'lat': -6.9175, 'long': 107.6191},
  'Surabaya': {'lat': -7.2504, 'long': 112.7688},
  'Yogyakarta': {'lat': -7.7956, 'long': 110.3695},
  'Bogor': {'lat': -6.5942, 'long': 106.7897},
  'Tangerang': {'lat': -6.1800, 'long': 106.6320},
};

// final List<Jadwal> jadwall = List<Jadwal>.from(
//   _jadwal.map((e) => Jadwal(
//         e['titikBerangkat'] as String,
//         DateTime.parse(e['waktuKeberangkatan'] as String),
//         e['titikKedatangan'] as String,
//         DateTime.parse(e['waktuKedatangan'] as String),
//         e['namaJadwal'] as String,
//         e['namaKendaraan'] as String,
//         double.parse(e['harga'].toString()),
//       )),
// );

// final List<Map<String, Object>> _jadwal = [
//   {
//     // "idJadwal": 1,
//     "titikBerangkat": "Jakarta",
//     "waktuKeberangkatan": "2023-11-20T10:00:00.000Z",
//     "titikKedatangan": "Semarang",
//     "waktuKedatangan": "2023-11-20T12:00:00.000Z",
//     // "idDriver": 101,
//     // "idKendaraan": 201,
//     "namaDriver": "Agus Wahyudi",
//     "namaKendaraan": "Isuzu Elf",
//     "harga": 143000,
//   },
//   {
//     // "idJadwal": 2,
//     "titikBerangkat": "Surabaya",
//     "waktuKeberangkatan": "2023-11-21T08:00:00.000Z",
//     "titikKedatangan": "Yogyakarta",
//     "waktuKedatangan": "2023-11-21T10:00:00.000Z",
//     // "idDriver": 102,
//     // "idKendaraan": 202,
//     "namaDriver": "Agus Wahyudi",
//     "namaKendaraan": "Isuzu Elf",
//     "harga": 143000,
//   },
//   {
//     // "idJadwal": 3,
//     "titikBerangkat": "Bandung",
//     "waktuKeberangkatan": "2023-11-22T15:00:00.000Z",
//     "titikKedatangan": "Jakarta",
//     "waktuKedatangan": "2023-11-22T17:00:00.000Z",
//     // "idDriver": 103,
//     // "idKendaraan": 203,
//     "namaDriver": "Agus Wahyudi",
//     "namaKendaraan": "Isuzu Elf",
//     "harga": 143000,
//   },
// ];

// final List<Jadwal> jadwalList = _jadwal
//     .map((e) => Jadwal(
//           // e['idJadwal'] as int,
//           e['titikBerangkat'] as String,
//           DateTime.parse(e['waktuKeberangkatan'] as String),
//           e['titikKedatangan'] as String,
//           DateTime.parse(e['waktuKedatangan'] as String),
//           // e['idDriver'] as int,
//           // e['idKendaraan'] as int,
//           e['namaDriver'] as String,
//           e['namaKendaraan'] as String,
//           double.parse(e['harga'].toString()),
//         ))
//     .toList(growable: false);
