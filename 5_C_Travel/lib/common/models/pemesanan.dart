// import flutter.ffi';

import 'dart:convert';

import 'package:tubes_5_c_travel/common/models/review_driver.dart';
import 'package:tubes_5_c_travel/common/models/tiket.dart';
import 'package:tubes_5_c_travel/common/models/jadwal.dart';

class Pemesanan {
  int? id;
  int? idUser;
  int? jumlahTiket;
  DateTime? tanggalPemesanan;
  String? statusPemesanan;
  List<Tiket>? tiketList;
  Jadwal? jadwal;
  ReviewDriver? reviewDriver;

  Pemesanan({
    this.id,
    this.idUser,
    this.jumlahTiket,
    this.tanggalPemesanan,
    this.statusPemesanan,
    this.tiketList,
    this.jadwal,
    this.reviewDriver,
  });

  double get totalBiaya {
    double total = 0;
    for (var tiket in tiketList ?? []) {
      total += tiket.hargaTiket ?? 0;
    }
    return total;
  }

  int get jumlahTiketVIP {
    return tiketList?.where((tiket) => tiket.kelas == 'VIP').length ?? 0;
  }

  int get jumlahTiketReguler {
    return tiketList?.where((tiket) => tiket.kelas == 'Reguler').length ?? 0;
  }

  double get hargaTiketVIP {
    var vipTicket = tiketList?.firstWhere(
      (tiket) => tiket.kelas == 'VIP',
    );
    return vipTicket?.hargaTiket ?? 0.0;
  }

  double get hargaTiketReguler {
    var regulerTicket = tiketList?.firstWhere(
      (tiket) => tiket.kelas == 'Reguler',
    );
    return regulerTicket?.hargaTiket ?? 0.0;
  }

  double get totalBiayaVIP {
    double total = 0;
    for (var tiket in tiketList ?? []) {
      if (tiket.kelas == 'VIP') {
        total += tiket.hargaTiket ?? 0;
      }
    }
    return total;
  }

  double get totalBiayaReguler {
    double total = 0;
    for (var tiket in tiketList ?? []) {
      if (tiket.kelas == 'Reguler') {
        total += tiket.hargaTiket ?? 0;
      }
    }
    return total;
  }

  factory Pemesanan.fromRawJson(String str) =>
      Pemesanan.fromJson(json.decode(str));

  factory Pemesanan.fromJson(Map<String, dynamic> json) {
    List<Tiket> tiketList = [];
    Jadwal? jadwal;

    if (json['tikets'] != null) {
      tiketList = <Tiket>[];
      json['tikets'].forEach((t) {
        tiketList.add(Tiket.fromJson(t));
      });
      if (tiketList.isNotEmpty) {
        jadwal = tiketList[0].jadwal!;
      }
    }

    return Pemesanan(
      id: json["id"],
      idUser: json["id_user"],
      jumlahTiket: json["jumlah_tiket"],
      tanggalPemesanan: json["tanggal_pemesanan"] != null
          ? DateTime.parse(json["tanggal_pemesanan"])
          : null,
      statusPemesanan: json["status_pemesanan"],
      tiketList: tiketList,
      jadwal: jadwal,
      reviewDriver: json['review_driver'] != null
          ? ReviewDriver.fromJson(json['review_driver'])
          : null,
    );
  }

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        "jumlah_tiket": jumlahTiket,
        "tanggal_pemesanan": tanggalPemesanan?.toIso8601String(),
      };
}

// var pemesananList = [
//   Pemesanan(
//     idPemesanan: 1,
//     tanggalPemesanan: DateTime(2023, 10, 30, 07, 00),
//     totalBiaya: 143000,
//     titikBerangkat: 'Jakarta',
//     waktuKeberangkatan: DateTime(2024, 10, 30, 10, 00),
//     titikKedatangan: 'Semarang',
//     waktuKedatangan: DateTime(2024, 10, 30, 14, 30),
//     statusPemesanan: 'ongoing',
//     noKendaraan: '012',
//     kelas: 'ekonomi',
//     idTiket: '00143',
//     penumpang: 2,
//     noKursi: '5, 8',
//   ),
// ];
