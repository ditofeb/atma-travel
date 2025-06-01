import 'package:flutter/material.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tubes_5_c_travel/common/models/jadwal.dart';
import 'dart:convert';

import 'package:tubes_5_c_travel/common/models/pemesanan.dart';
import 'package:tubes_5_c_travel/common/constants/fonts.dart';

class TicketView extends StatelessWidget {
  final Pemesanan pemesanan;
  const TicketView({super.key, required this.pemesanan});

  @override
  Widget build(BuildContext context) {
    String waktuBerangkat = DateFormat('MMM d, h:mm a')
        .format(pemesanan.jadwal!.waktuKeberangkatan!);
    String waktuDatang =
        DateFormat('MMM d, h:mm a').format(pemesanan.jadwal!.waktuKedatangan!);

    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/images/logo_only.png',
                    width: 60,
                    height: 60,
                  ),
                  SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Atma",
                        style: TextStyles.poppinsBold(fontSize: 20),
                      ),
                      Text(
                        "travel",
                        style: TextStyles.poppinsBold(fontSize: 20),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 8.0),
          const Divider(
            thickness: 1,
          ),
          const SizedBox(height: 12.0),

          // Bagian Keberangkatan dan Kedatangan
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pemesanan.jadwal!.titikKeberangkatan!,
                    style: TextStyles.poppinsNormal(fontSize: 14),
                  ),
                  const SizedBox(
                    height: 4.0,
                  ),
                  Text(
                    listKota[pemesanan.jadwal!.titikKeberangkatan!]!,
                    style: TextStyles.poppinsBold(fontSize: 24),
                  ),
                  SizedBox(height: 6),
                  Text(
                    waktuBerangkat,
                    style: TextStyles.poppinsNormal(fontSize: 12),
                  ),
                ],
              ),
              Icon(Icons.arrow_forward_rounded, size: 28),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    pemesanan.jadwal!.titikKedatangan!,
                    style: TextStyles.poppinsNormal(fontSize: 14),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    listKota[pemesanan.jadwal!.titikKedatangan!]!,
                    style: TextStyles.poppinsBold(fontSize: 24),
                  ),
                  SizedBox(height: 6.0),
                  Text(
                    waktuDatang,
                    style: TextStyles.poppinsNormal(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          const Divider(
            thickness: 1,
          ),
          const SizedBox(height: 12.0),
          // Bagian Tiket
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "No Kendaraan",
                    style: TextStyles.poppinsNormal(fontSize: 12),
                  ),
                  SizedBox(height: 4),
                  Text(
                    pemesanan.jadwal!.idKendaraan!.toString().padLeft(3, '0'),
                    style: TextStyles.poppinsNormal(fontSize: 16),
                  ),
                  const SizedBox(
                    height: 18.0,
                  ),
                  Text(
                    "Penumpang",
                    style: TextStyles.poppinsNormal(fontSize: 12),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "${pemesanan.tiketList!.length} Dewasa",
                    style: TextStyles.poppinsNormal(fontSize: 16),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Kelas",
                    style: TextStyles.poppinsNormal(fontSize: 12),
                  ),
                  SizedBox(height: 4),
                  Text(
                    pemesanan.tiketList![0].kelas!,
                    style: TextStyles.poppinsNormal(fontSize: 16),
                  ),
                  const SizedBox(
                    height: 18.0,
                  ),
                  Text(
                    "Kursi",
                    style: TextStyles.poppinsNormal(fontSize: 12),
                  ),
                  SizedBox(height: 4),
                  Text(
                    pemesanan.tiketList!.map((t) => t.kursi).join(", "),
                    style: TextStyles.poppinsNormal(fontSize: 16),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "ID Tiket",
                    style: TextStyles.poppinsNormal(fontSize: 12),
                  ),
                  SizedBox(height: 4),
                  Text(
                    pemesanan.tiketList![0].id!.toString().padLeft(3, '0'),
                    style: TextStyles.poppinsNormal(fontSize: 16),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12.0),

          DottedLine(
            direction: Axis.horizontal,
            alignment: WrapAlignment.center,
            lineLength: double.infinity,
            lineThickness: 1.0,
            dashLength: 6.0,
            dashColor: Colors.grey,
            dashGapLength: 6.0,
            dashGapColor: Colors.transparent,
          ),

          const SizedBox(height: 12.0),

          // QR Code
          QrImageView(
            data: jsonEncode({
              'titik_keberangkatan': pemesanan.jadwal!.titikKeberangkatan,
              'kode_titik_keberangkatan': 'JKT',
              'titik_Kedatangan': pemesanan.jadwal!.titikKedatangan,
              'kode_titik_Kedatangan': 'SMG',
              'waktu_Keberangkatan': waktuBerangkat,
              'waktu_kedatangan': waktuDatang,
              'no_kendaraan': pemesanan.jadwal!.idKendaraan,
              'kelas': pemesanan.tiketList![0].kelas,
              'id_tiket': pemesanan.tiketList![0].id,
              'no_kursi': ['5', '8']
            }),
            version: QrVersions.auto,
            size: 180,
            gapless: false,
            embeddedImage: AssetImage('assets/images/T(backup).png'),
            embeddedImageStyle: QrEmbeddedImageStyle(
              size: Size(36, 36),
            ),
          ),
        ],
      ),
    );
  }
}
