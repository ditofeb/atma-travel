import 'dart:ffi';

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:tubes_5_c_travel/common/constants/colors.dart';
import 'package:tubes_5_c_travel/common/models/pemesanan.dart';
import 'package:tubes_5_c_travel/common/models/pemesanan_client.dart';
import 'package:tubes_5_c_travel/common/widgets/alert_dialog.dart';
import 'package:tubes_5_c_travel/common/widgets/app_bar.dart';
import 'package:tubes_5_c_travel/common/constants/fonts.dart';
import 'package:tubes_5_c_travel/common/models/pembayaran.dart';
import 'package:tubes_5_c_travel/common/models/pembayaranClient.dart';
import 'package:tubes_5_c_travel/common/models/tiket.dart';
import 'package:tubes_5_c_travel/common/models/TiketClient.dart';
import 'package:tubes_5_c_travel/history/screens/history_screen.dart';
import 'package:tubes_5_c_travel/home/screens/home_screen.dart';

class PembayaranView extends ConsumerStatefulWidget {
  final List<Map<String, dynamic>> dataPenumpang;
  final Pemesanan pemesanan;

  const PembayaranView({
    super.key,
    required this.dataPenumpang,
    required this.pemesanan,
  });

  @override
  ConsumerState<PembayaranView> createState() => _PembayaranViewState();
}

class _PembayaranViewState extends ConsumerState<PembayaranView> {
  String? selectedMetode;
  String? selectedBank;

  void update(String? value) {
    setState(() {
      selectedMetode = value;
    });
  }

  void updateBank(String? value) {
    setState(() {
      selectedBank = value;
    });
  }

  void onSubmit() async {
    var response = await PemesananClient.create(widget.pemesanan);
    var pemesananData = Pemesanan.fromJson(json.decode(response.body)['data']);

    for (int i = 0; i < widget.dataPenumpang.length; i++) {
      try {
        Tiket tiket = Tiket(
            idPemesanan: pemesananData.id,
            idJadwal: widget.dataPenumpang[i]['jadwal'],
            kelas: widget.dataPenumpang[i]['kelas'],
            kursi: widget.dataPenumpang[i]['kursi'],
            hargaTiket: widget.dataPenumpang[i]['hargaTiket']);
        await TiketClient.create(tiket);
      } catch (e) {
        print(e.toString());
      }
    }

    Pembayaran pembayaran = Pembayaran(
      idPemesanan: pemesananData.id,
      metodePembayaran: selectedMetode,
      totalBiaya: widget.dataPenumpang[widget.dataPenumpang.length - 1]
              ['totalHargaTiket'] *
          1.1,
      status: 'Selesai',
      tanggalTransaksi: DateTime.now(),
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
      await PembayaranClient.create(pembayaran);

      Navigator.pop(dialogContext!);
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        title: 'Berhasil',
        text: 'Selamat! Anda telah berhasil memesan tiket.',
        confirmBtnText: 'Tutup',
        onConfirmBtnTap: () {
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
        },
      );

      ref.refresh(listPemesananProvider);
    } catch (e) {
      print('Gagal melakukan Pembayaran, ${e.toString()}');
      Navigator.pop(dialogContext!);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return SingleButtonAlertDialog(
            title: 'Pembayaran Gagal',
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
    String hargaSatuTiket = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    ).format(widget.dataPenumpang[0]['hargaTiket']!);
    String biayaAdmin = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    ).format(widget.dataPenumpang[widget.dataPenumpang.length - 1]
            ['totalHargaTiket'] *
        0.1);
    String totalHargaTiket = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    ).format(widget.dataPenumpang[widget.dataPenumpang.length - 1]
            ['totalHargaTiket'] *
        1.1);

    String generateUniqueId() {
      DateTime now = DateTime.now();
      String uniqueId =
          '${now.month.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}'
          '${now.hour.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}'
          '${now.millisecond.toString().padLeft(3, '0')}';
      return '#$uniqueId';
    }

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: CustomAppBar(
            title: 'Pembayaran',
            showLeadingIcon: true,
            onLeadingIconPressed: () {
              Navigator.pop(context);
            },
            centerTitle: true,
          ),
          body: Padding(
            padding: EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Row(
                    'ID Transaksi',
                    generateUniqueId(),
                  ),
                  SizedBox(height: 12),
                  widget.dataPenumpang.length == 1
                      ? _Row('Nama', widget.dataPenumpang[0]['nama']!)
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:
                              widget.dataPenumpang.asMap().entries.map((entry) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                entry.key == 0
                                    ? _Row(
                                        'Nama',
                                        entry.value['nama'] ??
                                            'Tidak diketahui')
                                    : _Row(
                                        ' ',
                                        entry.value['nama'] ??
                                            'Tidak diketahui'),
                                SizedBox(height: 12),
                              ],
                            );
                          }).toList(),
                        ),
                  SizedBox(height: 12),
                  _Row('Jumlah Tiket', widget.dataPenumpang.length.toString()),
                  SizedBox(height: 12),
                  widget.dataPenumpang.length == 1
                      ? _Row('Harga Tiket', hargaSatuTiket)
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:
                              widget.dataPenumpang.asMap().entries.map((entry) {
                            String hargaTiket = NumberFormat.currency(
                              locale: 'id_ID',
                              symbol: 'Rp',
                              decimalDigits: 0,
                            ).format(entry.value['hargaTiket']);

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                entry.key == 0
                                    ? _Row('Harga Tiket', hargaTiket)
                                    : _Row(' ', hargaTiket),
                                SizedBox(height: 12),
                              ],
                            );
                          }).toList(),
                        ),
                  SizedBox(height: 12),
                  _Row('Biaya Admin', biayaAdmin),
                  SizedBox(height: 12),
                  _Row('Total Harga', totalHargaTiket),
                  SizedBox(height: 50),
                  _Row('Metode Pembayaran', ' '),
                  SizedBox(height: 12),
                  metodePembayaran(onValueChanged: update),
                  selectedMetode != 'QRIS'
                      ? Column(
                          children: [
                            SizedBox(height: 12),
                            _Row('Bank', ' '),
                            JenisBank(
                              onBankSelected: updateBank,
                            ),
                          ],
                        )
                      : SizedBox(height: 144),
                  SizedBox(height: 80),
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.900,
                      child: ElevatedButton(
                        onPressed: onSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: themeColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Save',
                          style: TextStyles.poppinsBold(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _Row(String startText, String endText) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        startText,
        style: TextStyles.poppinsBold(
          fontSize: 14,
          color: Colors.black,
        ),
      ),
      Text(
        endText,
        style: TextStyles.poppinsNormal(
          fontSize: 14,
          color: Colors.black,
        ),
      ),
    ],
  );
}

class metodePembayaran extends StatefulWidget {
  const metodePembayaran({super.key, required this.onValueChanged});
  final ValueChanged<String?> onValueChanged;

  @override
  State<metodePembayaran> createState() => _metodePembayaranState();
}

class _metodePembayaranState extends State<metodePembayaran> {
  String? _selectedMetode;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        RadioListTile<String>(
          title: Text(
            'Transfer',
            style: TextStyles.poppinsNormal(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
          contentPadding: EdgeInsets.all(0),
          value: 'Transfer',
          groupValue: _selectedMetode,
          onChanged: (String? value) {
            setState(() {
              _selectedMetode = value;
            });
            widget.onValueChanged(value);
          },
        ),
        RadioListTile<String>(
          title: Text(
            'Virtual Account',
            style: TextStyles.poppinsNormal(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
          contentPadding: EdgeInsets.all(0),
          value: 'Virtual Account',
          groupValue: _selectedMetode,
          onChanged: (String? value) {
            setState(() {
              _selectedMetode = value;
            });
            widget.onValueChanged(value);
          },
        ),
        RadioListTile<String>(
          title: Text(
            'QRIS',
            style: TextStyles.poppinsNormal(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
          contentPadding: EdgeInsets.all(0),
          value: 'QRIS',
          groupValue: _selectedMetode,
          onChanged: (String? value) {
            setState(() {
              _selectedMetode = value;
            });
            widget.onValueChanged(value);
          },
        ),
      ],
    );
  }
}

class JenisBank extends StatefulWidget {
  final ValueChanged<String?> onBankSelected;

  const JenisBank({super.key, required this.onBankSelected});

  @override
  State<JenisBank> createState() => JenisBankState();
}

class JenisBankState extends State<JenisBank> {
  String? _selectedBank;
  bool? checkJenisPembayaran;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        RadioListTile(
          title: Row(children: [
            SizedBox(
                width: 40,
                height: 30,
                child: SvgPicture.asset('assets/images/logo-bca.svg')),
          ]),
          value: 'bca',
          groupValue: _selectedBank,
          onChanged: (String? value) {
            setState(() {
              _selectedBank = value;
            });
          },
          contentPadding: EdgeInsets.all(0),
        ),
        RadioListTile(
          title: Row(children: [
            SizedBox(
              width: 45,
              height: 25,
              child: Image(
                image: AssetImage('assets/images/logo_mandiri.png'),
                fit: BoxFit.cover,
              ),
            ),
          ]),
          value: 'mandiri',
          groupValue: _selectedBank,
          onChanged: (String? value) {
            setState(() {
              _selectedBank = value;
            });
          },
          contentPadding: EdgeInsets.all(0),
        ),
      ],
    );
  }
}
