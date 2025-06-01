import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tubes_5_c_travel/admin/driver/screens/driver_screen.dart';
import 'package:tubes_5_c_travel/admin/kendaraan/screens/kendaraan_screen.dart';
import 'package:tubes_5_c_travel/common/constants/colors.dart';
import 'package:tubes_5_c_travel/common/models/pemesanan.dart';
import 'package:tubes_5_c_travel/common/models/review_driver.dart';
import 'package:tubes_5_c_travel/common/models/review_driverClient.dart';
import 'package:tubes_5_c_travel/common/models/review_kendaraan.dart';
import 'package:tubes_5_c_travel/common/models/review_kendaraanClient.dart';
import 'package:tubes_5_c_travel/common/widgets/alert_dialog.dart';
import 'package:tubes_5_c_travel/common/widgets/app_bar.dart';
import 'package:tubes_5_c_travel/history/screens/trip_summary_screen.dart';

class AddReviewScreen extends ConsumerStatefulWidget {
  Pemesanan pemesanan;
  AddReviewScreen({super.key, required this.pemesanan});

  @override
  _AddReviewScreenState createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends ConsumerState<AddReviewScreen> {
  int driverRating = 0;
  int carRating = 0;
  final _formKey = GlobalKey<FormState>();
  TextEditingController driverReviewController = TextEditingController();
  TextEditingController carReviewController = TextEditingController();

  @override
  void dispose() {
    driverReviewController.dispose();
    carReviewController.dispose();
    super.dispose();
  }

  Widget buildRatingStars(int rating, Function(int) onRate) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            Icons.star,
            color: index < rating
                ? Color.fromARGB(255, 255, 217, 0)
                : Color(0xFFBDBDBD),
          ),
          onPressed: () => onRate(index + 1),
        );
      }),
    );
  }

  void onSubmit() async {
    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      print("form gagal disubmit.");
      return;
    }

    ReviewDriver reviewDriver = ReviewDriver(
      idDriver: widget.pemesanan.jadwal!.idDriver,
      idPemesanan: widget.pemesanan.id,
      rating: driverRating,
      komentar: driverReviewController.text,
    );
    ReviewKendaraan reviewKendaraan = ReviewKendaraan(
      idKendaraan: widget.pemesanan.jadwal!.idKendaraan,
      idPemesanan: widget.pemesanan.id,
      rating: carRating,
      komentar: carReviewController.text,
    );

    BuildContext? dialogContext;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        dialogContext = context;
        return Center(
            child: CircularProgressIndicator(
          color: themeColor,
        ));
      },
    );

    try {
      await ReviewDriverClient.create(reviewDriver);
      await ReviewKendaraanClient.create(reviewKendaraan);
      Navigator.pop(dialogContext!);
      Navigator.pop(context, true);

      ref.refresh(listDriverProvider);
      ref.refresh(listKendaraanProvider);
      ref.refresh(pemesananProvider(widget.pemesanan.id!));
    } catch (err) {
      Navigator.pop(dialogContext!);
      print(err.toString());
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return SingleButtonAlertDialog(
            title: 'Tambah Review Gagal',
            content: 'Terjadi kesalahan tak terduga. Silakan coba lagi.',
            buttonText: 'Mengerti',
            onPressed: () {
              Navigator.pop(context);
            },
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          appBar: CustomAppBar(
            title: 'Review',
            showLeadingIcon: true,
            showCheckIcon: true,
            onLeadingIconPressed: () {
              Navigator.pop(context);
            },
            onCheckIconPressed: () {
              print('Driver Rating: $driverRating');
              print('Driver Review: ${driverReviewController.text}');
              print('Car Rating: $carRating');
              print('Car Review: ${carReviewController.text}');
              onSubmit();
            },
          ),
          body: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage('assets/images/driver.png'),
                    ),
                    SizedBox(height: 10),
                    Text(
                      widget.pemesanan.jadwal!.driver!.nama!,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.pemesanan.jadwal!.kendaraan!.plat!,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    SizedBox(height: 20),
                    Divider(
                      color: Colors.blue,
                      thickness: 0.5,
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      'Bagaimana pengalaman Anda dengan pengemudi?',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    buildRatingStars(driverRating, (rating) {
                      setState(() {
                        driverRating = rating;
                      });
                    }),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      child: TextField(
                        controller: driverReviewController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: 'Tulis ulasan',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Divider(
                      color: Colors.blue,
                      thickness: 0.5,
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      'Bagaimana kondisi kendaraan?',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    buildRatingStars(carRating, (rating) {
                      setState(() {
                        carRating = rating;
                      });
                    }),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      child: TextField(
                        controller: carReviewController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: 'Tulis ulasan',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
