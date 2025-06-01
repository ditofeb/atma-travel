import 'package:flutter/material.dart';
import 'package:tubes_5_c_travel/common/constants/fonts.dart';
import 'package:tubes_5_c_travel/common/models/jadwal.dart';
import 'package:intl/intl.dart';

class ListJadwal extends StatefulWidget {
  final List<Jadwal> jadwalList;
  const ListJadwal({super.key, required this.jadwalList});

  @override
  State<ListJadwal> createState() => _ListJadwalState();
}

class _ListJadwalState extends State<ListJadwal> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: widget.jadwalList.length,
      itemBuilder: (context, index) {
        final Jadwal jadwal = widget.jadwalList[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          color: const Color.fromRGBO(231, 240, 255, 1),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat('dd MMMM yyyy')
                          .format(jadwal.waktuKeberangkatan!),
                      style: TextStyles.poppinsBold(fontSize: 16),
                    ),
                    Text(
                      NumberFormat.currency(
                              locale: 'id_ID', symbol: 'Rp', decimalDigits: 0)
                          .format(jadwal.harga),
                      style: TextStyles.poppinsBold(fontSize: 16),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          jadwal.titikKeberangkatan!,
                          style: TextStyles.poppinsBold(fontSize: 15),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '${jadwal.waktuKeberangkatan!.hour}:${jadwal.waktuKeberangkatan!.minute.toString().padLeft(2, '0')} AM',
                          style: TextStyles.poppinsNormal(
                              fontSize: 12, color: Colors.grey[700]),
                        ),
                      ],
                    ),
                    Icon(Icons.arrow_forward, color: Colors.black, size: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          jadwal.titikKedatangan!,
                          style: TextStyles.poppinsBold(fontSize: 15),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${jadwal.waktuKedatangan!.hour}:${jadwal.waktuKedatangan!.minute.toString().padLeft(2, '0')} PM',
                          style: TextStyles.poppinsNormal(
                              fontSize: 12, color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      jadwal.driver!.nama!,
                      style: TextStyles.poppinsBold(fontSize: 14),
                    ),
                    Text(
                      jadwal.kendaraan!.jenis!,
                      style: TextStyles.poppinsBold(fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
