import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tubes_5_c_travel/common/constants/colors.dart';
import 'package:tubes_5_c_travel/common/constants/fonts.dart';
import 'package:tubes_5_c_travel/admin/kendaraan/screens/kendaraan_screen.dart';
import 'package:tubes_5_c_travel/common/models/KendaraanClient.dart';
import 'package:tubes_5_c_travel/common/models/kendaraan.dart';
import 'package:tubes_5_c_travel/common/widgets/alert_dialog.dart';

class InputKendaraanForm extends ConsumerStatefulWidget {
  const InputKendaraanForm({super.key});

  @override
  ConsumerState<InputKendaraanForm> createState() => _InputKendaraanFormState();
}

class _InputKendaraanFormState extends ConsumerState<InputKendaraanForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nomorPlatController = TextEditingController();
  final TextEditingController kapasitasController = TextEditingController();

  String? selectedJenisKendaraan;
  bool isSubmitted = false;

  @override
  void dispose() {
    nomorPlatController.dispose();
    kapasitasController.dispose();
    super.dispose();
  }

  void onSubmit() async {
    setState(() {
      isSubmitted = true;
    });

    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      return;
    }

    Kendaraan kendaraan = Kendaraan(
      jenis: selectedJenisKendaraan ?? '',
      plat: nomorPlatController.text,
      kapasitas: int.tryParse(kapasitasController.text),
      totalRating: 0,
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
      await KendaraanClient.create(kendaraan);
      Navigator.pop(dialogContext!);
      Navigator.pop(context, true);

      ref.refresh(listKendaraanProvider);
    } catch (err) {
      Navigator.pop(dialogContext!);
      print(err.toString());
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return SingleButtonAlertDialog(
            title: 'Tambah Kendaraan Gagal',
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
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Jenis Kendaraan",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            DropdownButtonFormField<String>(
              value: selectedJenisKendaraan,
              hint: Text('Pilih Jenis Kendaraan'),
              onChanged: (String? newValue) {
                setState(() {
                  selectedJenisKendaraan = newValue;
                });
              },
              items: jenisKendaraanMap.keys
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(
                hintStyle: const TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color.fromRGBO(131, 180, 255, 1)),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: themeColor, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Jenis Kendaraan tidak boleh kosong';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            Text(
              "Nomor Plat",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextFormField(
              controller: nomorPlatController,
              decoration: InputDecoration(
                hintText: 'Masukkan Nomor Plat',
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromRGBO(131, 180, 255, 1)),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: themeColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nomor plat tidak boleh kosong';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            Text(
              "Kapasitas Penumpang",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextFormField(
              controller: kapasitasController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Masukkan Kapasitas Kendaraan',
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromRGBO(131, 180, 255, 1)),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: themeColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Kapasitas tidak boleh kosong';
                }
                if (int.tryParse(value) == null) {
                  return 'Kapasitas harus berupa angka';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: onSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Tambah Kendaraan',
                  style:
                      TextStyles.poppinsBold(fontSize: 17, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
