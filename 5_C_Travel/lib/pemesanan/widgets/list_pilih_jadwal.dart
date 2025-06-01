import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:tubes_5_c_travel/common/constants/colors.dart';
import 'package:tubes_5_c_travel/common/constants/fonts.dart';
import 'package:tubes_5_c_travel/common/models/jadwal.dart';
import 'package:intl/intl.dart';
import 'package:tubes_5_c_travel/home/screens/input_form_pemesanan.dart';

class ListPilihJadwal extends StatefulWidget {
  final List<Jadwal> jadwalList;
  final int passengerCount;
  const ListPilihJadwal(
      {super.key, required this.jadwalList, required this.passengerCount});

  @override
  State<ListPilihJadwal> createState() => _ListJadwalState();
}

class _ListJadwalState extends State<ListPilihJadwal> {
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
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        PersistentNavBarNavigator.pushNewScreen(
                          context,
                          withNavBar: false,
                          screen: InputFormPemesanan(
                              jadwal: jadwal,
                              passengerCount: widget.passengerCount),
                          pageTransitionAnimation: PageTransitionAnimation.fade,
                        );
                        print('Chosen Schedule: ${jadwal.waktuKeberangkatan}');
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: themeColor,
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Choose',
                        style: TextStyles.poppinsBold(
                            fontSize: 12, color: Colors.white),
                      ),
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
