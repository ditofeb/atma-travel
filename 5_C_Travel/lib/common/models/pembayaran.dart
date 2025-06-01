import 'dart:convert';

import 'package:tubes_5_c_travel/common/models/pemesanan.dart';

class Pembayaran {
  int? id;
  int? idPemesanan;
  String? metodePembayaran;
  double? totalBiaya;
  String? status;
  DateTime? tanggalTransaksi;

  Pembayaran({
    this.id,
    this.idPemesanan,
    this.metodePembayaran,
    this.totalBiaya,
    this.status,
    this.tanggalTransaksi,
  });

  factory Pembayaran.fromJson(Map<String, dynamic> json) => Pembayaran(
    id: json["id"],
    idPemesanan: json["id_pemesanan"],
    metodePembayaran: json["metode_pembayaran"],
    totalBiaya: json["total_biaya"],
    status: json["status"],
    tanggalTransaksi: json["tanggal_transaksi"] != null 
      ? DateTime.parse(json["tanggal_transaksi"]) 
      : null,
  );

  factory Pembayaran.fromRawJson(String str) => Pembayaran.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
    "id_pemesanan": idPemesanan,    
    "metode_pembayaran": metodePembayaran,
    "total_biaya": totalBiaya,
    "status": status,
  };
}