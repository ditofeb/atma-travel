import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tubes_5_c_travel/admin/driver/screens/driver_screen.dart';
import 'package:tubes_5_c_travel/common/constants/colors.dart';
import 'package:tubes_5_c_travel/common/constants/fonts.dart';
import 'package:tubes_5_c_travel/common/models/Driver.dart';
import 'package:tubes_5_c_travel/common/models/DriverClient.dart';
import 'package:tubes_5_c_travel/common/widgets/alert_dialog.dart';

class InputDriverForm extends ConsumerStatefulWidget {
  const InputDriverForm({super.key});

  @override
  ConsumerState<InputDriverForm> createState() => _InputDriverFormState();
}

class _InputDriverFormState extends ConsumerState<InputDriverForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  // final TextEditingController dateOfBirthController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  DateTime? selectedDate;

  bool isSubmitted = false;

  @override
  void dispose() {
    nameController.dispose();
    // dateOfBirthController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  void onSubmit() async {
    setState(() {
      isSubmitted = true;
    });

    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      return;
    }

    Driver driver = Driver(
      nama: nameController.text,
      tanggalLahir: selectedDate,
      nomorTelp: phoneNumberController.text,
      totalRating: 0
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
      await DriverClient.create(driver);
      Navigator.pop(dialogContext!);
      Navigator.pop(context, true);

      ref.refresh(listDriverProvider);
    } catch (err) {
      Navigator.pop(dialogContext!);
      print(err.toString());
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return SingleButtonAlertDialog(
            title: 'Tambah Driver Gagal',
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        // dateOfBirthController.text = '${picked.toLocal()}'.split(' ')[0];
      });
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
              "Nama Driver",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'Masukkan Nama Driver',
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
                  return 'Nama tidak boleh kosong';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            Text(
              "Tanggal Lahir",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: InputDecorator(
                decoration: InputDecoration(
                  hintText: 'Masukkan Tanggal Lahir',
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
                    borderSide: BorderSide(
                        color: isSubmitted && selectedDate == null
                            ? Colors.red
                            : Colors.transparent,
                        width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: isSubmitted && selectedDate == null
                            ? Colors.red
                            : Colors.transparent,
                        width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today, color: Colors.black),
                    SizedBox(width: 8),
                    Text(
                      selectedDate == null
                          ? 'Pilih Tanggal'
                          : '${selectedDate!.toLocal()}'.split(' ')[0],
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (isSubmitted && selectedDate == null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Tanggal lahir harus dipilih!',
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            SizedBox(height: 16),
            Text(
              "Nomor Telepon",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextFormField(
              controller: phoneNumberController,
              keyboardType: TextInputType.numberWithOptions(
                  decimal: false, signed: false),
              decoration: InputDecoration(
                hintText: 'Masukkan Nomor Telepon',
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
                  return 'Nomor Telepon tidak boleh kosong';
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
                  'Tambah Driver',
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
