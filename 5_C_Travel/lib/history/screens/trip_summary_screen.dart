import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tubes_5_c_travel/common/constants/colors.dart';
import 'package:tubes_5_c_travel/common/models/pemesanan_client.dart';
import 'package:tubes_5_c_travel/common/widgets/alert_dialog.dart';
import 'package:tubes_5_c_travel/common/widgets/app_bar.dart';
import 'package:tubes_5_c_travel/common/constants/fonts.dart';
import 'package:tubes_5_c_travel/common/models/pemesanan.dart';
import 'package:tubes_5_c_travel/history/screens/add_review.dart';
import 'package:tubes_5_c_travel/history/screens/history_screen.dart';
import 'package:tubes_5_c_travel/history/screens/pdf_view.dart';
import 'package:tubes_5_c_travel/history/screens/ticket_screen.dart';

final pemesananProvider =
    FutureProvider.family<Pemesanan, int>((ref, pemesananId) async {
  return await PemesananClient.fetchOne(pemesananId);
});

class TripSummaryScreen extends ConsumerWidget {
  final int pemesananId;
  const TripSummaryScreen({super.key, required this.pemesananId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pemesananListener = ref.watch(pemesananProvider(pemesananId));

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          appBar: CustomAppBar(
            title: 'Trip Summary',
            showLeadingIcon: true,
            onLeadingIconPressed: () {
              Navigator.pop(context);
            },
            showCheckIcon: pemesananListener.when(
              data: (pemesanan) {
                print(pemesanan.statusPemesanan);
                return pemesanan.statusPemesanan != 'Selesai';
              },
              error: (err, s) => true,
              loading: () => true,
            ),
            onCheckIconPressed: () async {
              try {
                await PemesananClient.setSelesai(pemesananId);
                Navigator.pop(context, true);
                ref.refresh(listPemesananProvider);
                ref.refresh(pemesananProvider(pemesananId));
              } catch (e) {
                print(e.toString());
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return SingleButtonAlertDialog(
                      title: 'Gagal Menyelesaikan Pemesanan',
                      content:
                          'Terjadi kesalahan tak terduga. Silakan coba lagi.',
                      buttonText: 'Mengerti',
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    );
                  },
                );
              }
            },
          ),
          body: pemesananListener.when(
            data: (pemesanan) {
              return buildTripContent(context, pemesanan);
            },
            error: (err, s) => Center(
              child: Text(err.toString()),
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(
                color: themeColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTripContent(BuildContext context, Pemesanan pemesanan) {
    String tglPemesanan =
        DateFormat('d MMMM, h:mm a').format(pemesanan.tanggalPemesanan!);
    String hargaTiket = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    ).format(pemesanan.totalBiaya);
    String biayaAdmin = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    ).format(pemesanan.totalBiaya * 0.1);
    String biayaAkhir = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    ).format(pemesanan.totalBiaya * 1.1);

    return Padding(
      padding: const EdgeInsets.all(13.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Atma travel',
                style: TextStyles.poppinsBold(fontSize: 20),
              ),
              Text(
                tglPemesanan,
                style: TextStyles.poppinsNormal(fontSize: 12),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                pemesanan.statusPemesanan == 'Selesai'
                    ? 'Trip Completed'
                    : 'Trip Ongoing',
                style: TextStyles.poppinsBold(fontSize: 12, color: themeColor),
              ),
              Text(
                'ID Pemesanan ${pemesanan.id.toString().padLeft(3, '0')}',
                style: TextStyles.poppinsNormal(fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 18.0),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color.fromRGBO(131, 180, 255, 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 20),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Driver',
                    style: TextStyles.poppinsBold(fontSize: 15),
                  ),
                ),
                const SizedBox(height: 6.0),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundImage: AssetImage('assets/images/driver.png'),
                      backgroundColor: Colors.white,
                    ),
                    const SizedBox(width: 13.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            pemesanan.jadwal!.driver!.nama!,
                            style: TextStyles.poppinsBold(fontSize: 12),
                          ),
                          Text(
                            pemesanan.jadwal!.kendaraan!.jenis!,
                            style: TextStyles.poppinsNormal(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    if (pemesanan.statusPemesanan == 'Selesai')
                      SizedBox(
                        height: 30,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 3,
                            backgroundColor: pemesanan.reviewDriver == null
                                ? themeColor
                                : Colors.grey,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 5.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          onPressed: pemesanan.reviewDriver != null
                              ? null
                              : () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddReviewScreen(
                                        pemesanan: pemesanan,
                                      ),
                                    ),
                                  );

                                  if (result == true) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: Colors.green,
                                        content: Text(
                                          "Review berhasil ditambahkan!",
                                          style: TextStyles.poppinsBold(
                                            fontSize: 15,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                },
                          child: Text(
                            pemesanan.reviewDriver == null
                                ? 'Tambah Review'
                                : 'Sudah Direview',
                            style: TextStyles.poppinsBold(
                              fontSize: 12,
                              color: pemesanan.reviewDriver == null
                                  ? Colors.white
                                  : const Color.fromARGB(255, 82, 82, 82),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6.0),
                const Divider(thickness: 1, color: themeColor),
                const SizedBox(height: 6.0),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Trip Details',
                    style: TextStyles.poppinsBold(fontSize: 15),
                  ),
                ),
                const SizedBox(height: 4.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.directions_bus_rounded),
                    const SizedBox(
                      width: 22.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pickup Location',
                          style: TextStyles.poppinsNormal(fontSize: 10),
                        ),
                        Text(
                          pemesanan.jadwal!.titikKeberangkatan!,
                          style: TextStyles.poppinsBold(fontSize: 15),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16.0,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 10.0,
                      ),
                      Column(
                        children: [
                          Container(
                            width: 4,
                            height: 4,
                            decoration: ShapeDecoration(
                              color: Colors.black,
                              shape: OvalBorder(),
                            ),
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Container(
                            width: 4,
                            height: 4,
                            decoration: ShapeDecoration(
                              color: Colors.black,
                              shape: OvalBorder(),
                            ),
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Container(
                            width: 4,
                            height: 4,
                            decoration: ShapeDecoration(
                              color: Colors.black,
                              shape: OvalBorder(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.location_on_rounded),
                    const SizedBox(
                      width: 22.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Destination',
                          style: TextStyles.poppinsNormal(fontSize: 10),
                        ),
                        Text(
                          pemesanan.jadwal!.titikKedatangan!,
                          style: TextStyles.poppinsBold(fontSize: 15),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12.0),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 5),
                  child: SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TicketScreen(pemesanan: pemesanan),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 3,
                        backgroundColor: themeColor,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 5.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      child: Text(
                        'View Ticket',
                        style: TextStyles.poppinsBold(
                            fontSize: 15, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12.0,
                ),
                const Divider(
                  thickness: 1,
                  color: themeColor,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Payment Details',
                    style: TextStyles.poppinsBold(fontSize: 15),
                  ),
                ),
                const SizedBox(height: 6.0),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Jumlah Penumpang',
                            style: TextStyles.poppinsNormal(fontSize: 12)),
                        Text('${pemesanan.jumlahTiket} Orang',
                            style: TextStyles.poppinsNormal(fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 6.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Harga Tiket',
                            style: TextStyles.poppinsNormal(fontSize: 12)),
                        Text(hargaTiket,
                            style: TextStyles.poppinsNormal(fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 6.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Biaya Admin',
                            style: TextStyles.poppinsNormal(fontSize: 12)),
                        Text(biayaAdmin,
                            style: TextStyles.poppinsNormal(fontSize: 12)),
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
                    ),
                    const SizedBox(height: 12.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total',
                            style: TextStyles.poppinsNormal(fontSize: 12)),
                        Text(biayaAkhir,
                            style: TextStyles.poppinsNormal(fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PdfPreviewPage(
                        pemesanan: pemesanan,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  elevation: 3,
                  backgroundColor: themeColor,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 5.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text(
                  'Download Bill',
                  style:
                      TextStyles.poppinsBold(fontSize: 15, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
