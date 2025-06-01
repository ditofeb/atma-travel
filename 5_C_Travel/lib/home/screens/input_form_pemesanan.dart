import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'dart:convert';
import 'package:tubes_5_c_travel/common/constants/colors.dart';
import 'package:tubes_5_c_travel/common/constants/fonts.dart';
import 'package:tubes_5_c_travel/common/models/jadwal.dart';
import 'package:tubes_5_c_travel/common/models/pemesanan.dart';
import 'package:tubes_5_c_travel/common/models/TiketClient.dart';
import 'package:tubes_5_c_travel/common/models/pemesanan_client.dart';
import 'package:tubes_5_c_travel/common/models/tiket.dart';
import 'package:tubes_5_c_travel/common/widgets/app_bar.dart';
import 'package:tubes_5_c_travel/common/widgets/input_form.dart';
import 'package:tubes_5_c_travel/pemesanan/screens/pembayaran_view.dart';

class InputFormPemesanan extends StatefulWidget {
  Jadwal jadwal;
  final int passengerCount;
  InputFormPemesanan(
      {super.key, required this.jadwal, required this.passengerCount});

  @override
  _InputFormPemesananState createState() => _InputFormPemesananState();
}

class _InputFormPemesananState extends State<InputFormPemesanan> {
  List<TextEditingController> namaPenumpangController = [];
  List<String> namaPenumpang = [];
  List<String> kelasDipilih = [];
  List<double> hargaTiket = [];
  int sisaVIP = 0;
  int sisaReguler = 0;
  int kapasitasKendaraan = 0;
  int startVIP = 0;
  int startReguler = 0;
  late DateTime idTransaksi;
  String? tipeKelas;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.passengerCount; i++) {
      namaPenumpangController.add(TextEditingController());
      namaPenumpang.add("");
      kelasDipilih.add("");
    }
    sisaVIP = widget.jadwal.sisaVIP ?? 0;
    sisaReguler = widget.jadwal.sisaReguler ?? 0;
    kapasitasKendaraan = widget.jadwal.kendaraan!.kapasitas!;
    startVIP = sisaVIP;
    startReguler = kapasitasKendaraan - sisaReguler + 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Form Pemesanan',
        showLeadingIcon: true,
        onLeadingIconPressed: () {
          Navigator.pop(context);
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Detail Perjalanan Section
            Text('Detail Perjalanan',
                style: TextStyles.poppinsBold(fontSize: 15)),
            const SizedBox(height: 8),
            Text(
              DateFormat('EEEE, d MMMM yyyy')
                  .format(widget.jadwal.waktuKeberangkatan!),
              style: TextStyles.poppinsNormal(fontSize: 15),
            ),
            const SizedBox(
              height: 8.0,
            ),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color.fromRGBO(239, 244, 255, 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.jadwal.titikKeberangkatan!,
                    style: TextStyles.poppinsBold(fontSize: 15),
                  ),
                  Icon(Icons.arrow_forward),
                  Text(
                    widget.jadwal.titikKedatangan!,
                    style: TextStyles.poppinsBold(fontSize: 15),
                  ),
                  // Text(
                  //   DateFormat('EEEE, d MMMM yyyy')
                  //       .format(widget.jadwal.waktuKeberangkatan!),
                  // ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Divider(),

            // Data Penumpang Section
            Text('Data Penumpang', style: TextStyles.poppinsBold(fontSize: 15)),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (int i = 0; i < widget.passengerCount; i++)
                      ListTile(
                        leading: Icon(Icons.person,
                            color: Color.fromRGBO(131, 180, 255, 1)),
                        title: Text(
                          'Penumpang ${i + 1} : ${namaPenumpang[i]}',
                          style: TextStyles.poppinsNormal(fontSize: 15),
                        ),
                        trailing: namaPenumpang[i] == ""
                            ? Icon(Icons.arrow_forward_ios, color: Colors.grey)
                            : Icon(
                                Icons.check,
                                color: Colors.grey,
                                size: 28,
                              ),
                        onTap: () {
                          _inputPenumpang(i);
                        },
                      ),
                    Divider(),
                  ],
                ),
              ),
            ),
            // Divider(),

            // Spacer(),
            const SizedBox(
              height: 20.0,
            ),

            // Lanjutkan Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  bool dataPenumpangTerisi = true;

                  for(int i = 0; i< widget.passengerCount; i++){
                    if(namaPenumpang[i] == ""){
                      dataPenumpangTerisi = false;
                      break;
                    }
                  }

                  if(!dataPenumpangTerisi){
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Harap Lengkapi data penumpang'),
                        backgroundColor : Colors.red,
                      ),
                    );
                    return;
                  }
                  Pemesanan pemesanan = Pemesanan(
                    jumlahTiket: widget.passengerCount,
                    tanggalPemesanan: DateTime.now(),
                  );

                  final List<Map<String, dynamic>> dataPenumpang = [];
                  idTransaksi = DateTime.now();
                  int count = 1;
                  double totalHargaTiket = 0;
                  String tanggalTransaksi =
                      DateFormat('yyyyMMdd$count').format(DateTime.now());
                  count++;
                  String nomorKursi;

                  for (int i = 0; i < widget.passengerCount; i++) {
                    if (kelasDipilih[i] == "VIP") {
                      hargaTiket.add((widget.jadwal.harga ?? 0) * 1.5);
                      nomorKursi = 'A$startVIP';
                      startVIP++;
                    } else {
                      hargaTiket.add((widget.jadwal.harga ?? 0));
                      nomorKursi = 'B$startReguler';
                      startReguler++;
                    }
                    totalHargaTiket += hargaTiket[i];

                    dataPenumpang.add({
                      'nama': namaPenumpang[i],
                      'idTrasaksi': tanggalTransaksi,
                      'hargaTiket': hargaTiket[i],
                      'totalHargaTiket': totalHargaTiket,
                      'jadwal': widget.jadwal.id,
                      'kelas': kelasDipilih[i].toString(),
                      'kursi': nomorKursi,
                    });
                  }

                  PersistentNavBarNavigator.pushNewScreen(
                    context,
                    screen: PembayaranView(
                      dataPenumpang: dataPenumpang,
                      pemesanan: pemesanan,
                    ),
                    withNavBar: false,
                    pageTransitionAnimation: PageTransitionAnimation.fade,
                  );
                  // Navigator.pop(context);

                  // try {
                  //   var response = await PemesananClient.create(pemesanan);
                  //   if (response.statusCode == 201) {
                  //     var pemesananData = Pemesanan.fromJson(
                  //         json.decode(response.body)['data']);
                  //   } else {
                  //     print('Gagal membuat pemesanan');
                  //   }
                  // } catch (e) {
                  //   print("Error: $e");
                  // }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeColor,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Lanjutkan',
                  style:
                      TextStyles.poppinsBold(fontSize: 15, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _inputPenumpang(index) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        String tempKelas = kelasDipilih[index];
        print(tempKelas);
        return SizedBox(
          height: 500,
          child: Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.88,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Data Penumpang ${index + 1}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black),
                  ),
                  SizedBox(height: 20),
                  InputForm(
                    (p0) => p0 == null || p0.isEmpty
                        ? "Nama Penumpang tidak boleh kosong"
                        : null,
                    controller: namaPenumpangController[index],
                    titleTxt: "Nama Lengkap",
                    hintTxt: "Nama Lengkap",
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Tipe Kelas (VIP: $sisaVIP | Reguler: $sisaReguler)",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: themeColor),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: kelasDipilih[index].isEmpty
                                ? null
                                : kelasDipilih[index],
                            hint: Text("Pilih Tipe Kelas"),
                            icon: Icon(Icons.arrow_drop_down),
                            isExpanded: true,
                            onChanged: (String? newValue) {
                              setState(() {
                                kelasDipilih[index] = newValue!;
                              });
                            },
                            items: <String>['VIP', 'Reguler']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value.toString()),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.88,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              kelasDipilih[index] = kelasDipilih[index].isEmpty
                                  ? 'Reguler'
                                  : kelasDipilih[index];
                              if (tempKelas == "") {
                                if (kelasDipilih[index] == 'Reguler') {
                                  sisaReguler -= 1;
                                } else {
                                  sisaVIP -= 1;
                                }
                              } else if (kelasDipilih[index] != tempKelas) {
                                if (kelasDipilih[index] == 'Reguler') {
                                  sisaReguler -= 1;
                                  sisaVIP += 1;
                                } else {
                                  sisaVIP -= 1;
                                  sisaReguler += 1;
                                }
                              }
                              namaPenumpang[index] =
                                  namaPenumpangController[index].text;
                            });
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromRGBO(131, 180, 255, 1),
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Simpan',
                            style: TextStyles.poppinsBold(
                                fontSize: 15, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
