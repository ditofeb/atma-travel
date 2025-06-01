import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:tubes_5_c_travel/common/models/pemesanan.dart';
import 'package:tubes_5_c_travel/history/screens/trip_summary_screen.dart';
import 'package:tubes_5_c_travel/common/constants/fonts.dart';

class ListPemesanan extends StatelessWidget {
  List<Pemesanan> pemesananList;
  final VoidCallback onFilterChange;
  ListPemesanan({
    super.key,
    required this.pemesananList,
    required this.onFilterChange,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        pemesananList
            .sort((a, b) => b.tanggalPemesanan!.compareTo(a.tanggalPemesanan!));
        final Pemesanan pemesanan = pemesananList[index];

        String tglPemesanan =
            DateFormat('d MMMM yyyy').format(pemesanan.tanggalPemesanan!);
        String waktuBerangkat =
            DateFormat('h:mm a').format(pemesanan.jadwal!.waktuKeberangkatan!);
        String waktuDatang =
            DateFormat('h:mm a').format(pemesanan.jadwal!.waktuKedatangan!);
        String biayaPemesanan = NumberFormat.currency(
          locale: 'id_ID',
          symbol: 'Rp',
          decimalDigits: 0,
        ).format(pemesanan.totalBiaya * 1.1);

        return InkWell(
          onTap: () {
            PersistentNavBarNavigator.pushNewScreen(
              context,
              screen: TripSummaryScreen(
                pemesananId: pemesanan.id!,
              ),
              withNavBar: false,
              pageTransitionAnimation: PageTransitionAnimation.fade,
            ).then((result) {
              if (result == true) {
                onFilterChange();
              }
            });
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color.fromRGBO(131, 180, 255, 0.4),
            ),
            height: MediaQuery.of(context).size.height * 0.105,
            child: Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        tglPemesanan,
                        style: TextStyles.poppinsBold(
                            fontSize: 12, color: Colors.black),
                      ),
                      Text(
                        biayaPemesanan,
                        style: TextStyles.poppinsBold(
                            fontSize: 12, color: Colors.black),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            pemesanan.jadwal!.titikKeberangkatan!,
                            style: TextStyles.poppinsNormal(
                                fontSize: 12, color: Colors.black),
                          ),
                          Text(
                            waktuDatang,
                            style: TextStyles.poppinsNormal(
                                fontSize: 12, color: Colors.black),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.black,
                        size: 30,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            pemesanan.jadwal!.titikKedatangan!,
                            style: TextStyles.poppinsNormal(
                                fontSize: 12, color: Colors.black),
                          ),
                          Text(
                            waktuBerangkat,
                            style: TextStyles.poppinsNormal(
                                fontSize: 12, color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
      itemCount: pemesananList.length,
    );
  }
}
