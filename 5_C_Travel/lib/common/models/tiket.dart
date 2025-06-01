import 'dart:convert';

import 'package:tubes_5_c_travel/common/models/jadwal.dart';

class Tiket {
  int? id;
  int? idPemesanan;
  int? idJadwal;
  String? kelas;
  double? hargaTiket;
  String? kursi;
  Jadwal? jadwal;

  Tiket({
    this.id,
    this.idPemesanan,
    this.idJadwal,
    this.kelas,
    this.hargaTiket,
    this.kursi,
    this.jadwal,
  });

  factory Tiket.fromRawJson(String str) => Tiket.fromJson(json.decode(str));

  factory Tiket.fromJson(Map<String, dynamic> json) => Tiket(
        id: json["id"],
        idPemesanan: json["id_pemesanan"],
        idJadwal: json["id_jadwal"],
        kelas: json["kelas"],
        hargaTiket: json["harga_tiket"] != null
            ? double.tryParse(json["harga_tiket"].toString())
            : null,
        kursi: json['kursi'],
        jadwal: json['jadwal'] != null ? Jadwal.fromJson(json['jadwal']) : null,
      );

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        "id_pemesanan": idPemesanan,
        "id_jadwal": idJadwal,
        "kelas": kelas,
        "kursi": kursi,
        "harga_tiket": hargaTiket!.toStringAsFixed(0),
      };
}
