import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tubes_5_c_travel/admin/driver/screens/driver_screen.dart';
import 'package:tubes_5_c_travel/admin/jadwal/screens/jadwal_screen.dart';
import 'package:tubes_5_c_travel/admin/kendaraan/screens/kendaraan_screen.dart';
import 'package:tubes_5_c_travel/common/constants/colors.dart';
import 'package:tubes_5_c_travel/common/constants/fonts.dart';
import 'package:tubes_5_c_travel/common/models/Driver.dart';
import 'package:tubes_5_c_travel/common/models/JadwalClient.dart';
import 'package:tubes_5_c_travel/common/models/jadwal.dart';
import 'package:tubes_5_c_travel/common/models/kendaraan.dart';
import 'package:tubes_5_c_travel/common/widgets/alert_dialog.dart';

class InputJadwalForm extends ConsumerStatefulWidget {
  const InputJadwalForm({super.key});

  @override
  ConsumerState<InputJadwalForm> createState() => _InputJadwalFormState();
}

class _InputJadwalFormState extends ConsumerState<InputJadwalForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController hargaController = TextEditingController();

  String? selectedTitikKeberangkatan;
  String? selectedTitikKedatangan;
  DateTime? waktuKeberangkatan;
  DateTime? waktuKedatangan;
  Driver? selectedDriver;
  Kendaraan? selectedKendaraan;

  @override
  void dispose() {
    hargaController.dispose();
    super.dispose();
  }

  void onSubmit() async {
    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      return;
    }

    Jadwal jadwal = Jadwal(
        titikKeberangkatan: selectedTitikKeberangkatan,
        titikKedatangan: selectedTitikKedatangan,
        waktuKeberangkatan: waktuKeberangkatan,
        waktuKedatangan: waktuKedatangan,
        idDriver: selectedDriver!.id,
        idKendaraan: selectedKendaraan!.id,
        harga: double.tryParse(hargaController.text));

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
      await JadwalClient.create(jadwal);
      Navigator.pop(dialogContext!);
      Navigator.pop(context, true);

      ref.refresh(listJadwalProvider);
    } catch (err) {
      Navigator.pop(dialogContext!);
      print(err.toString());
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return SingleButtonAlertDialog(
            title: 'Tambah Jadwal Gagal',
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

  // Fungsi untuk memilih waktu (tanggal + jam)
  Future<void> _selectDateTime(BuildContext context, bool isDeparture) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: 12, minute: 0), // Waktu default
      );

      if (pickedTime != null) {
        final DateTime selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        setState(() {
          if (isDeparture) {
            waktuKeberangkatan = selectedDateTime;
          } else {
            waktuKedatangan = selectedDateTime;
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final driverListener = ref.watch(listDriverProvider);
    final kendaraanListener = ref.watch(listKendaraanProvider);

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Titik Awal",
              style: TextStyles.poppinsBold(fontSize: 14),
            ),
            DropdownButtonFormField<String>(
              value: selectedTitikKeberangkatan,
              items: listKota.entries.map((city) {
                return DropdownMenuItem<String>(
                  value: city.key,
                  child: Text('${city.key} - ${city.value}'),
                );
              }).toList(),
              decoration: InputDecoration(
                hintText: 'Pilih Titik Keberangkatan',
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
              onChanged: (String? newValue) {
                setState(() {
                  selectedTitikKeberangkatan = newValue;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Titik Keberangkatan tidak boleh kosong';
                }
                if (value == selectedTitikKedatangan) {
                  return 'Titik awal dan tujuan tidak boleh sama';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            Text(
              "Titik Kedatangan/Tujuan",
              style: TextStyles.poppinsBold(fontSize: 14),
            ),
            DropdownButtonFormField<String>(
              value: selectedTitikKedatangan,
              items: listKota.entries.map((city) {
                return DropdownMenuItem<String>(
                  value: city.key,
                  child: Text('${city.key} - ${city.value}'),
                );
              }).toList(),
              decoration: InputDecoration(
                hintText: 'Pilih Titik Kedatangan/Tujuan',
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
              onChanged: (String? newValue) {
                setState(() {
                  selectedTitikKedatangan = newValue;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Titik Kedatangan tidak boleh kosong';
                }
                if (value == selectedTitikKeberangkatan) {
                  return 'Titik awal dan tujuan tidak boleh sama';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            Text(
              "Harga",
              style: TextStyles.poppinsBold(fontSize: 14),
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: hargaController,
              decoration: InputDecoration(
                hintText: 'Masukkan Harga',
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
                  return 'Harga tidak boleh kosong';
                }
                try {
                  final double parsedValue = double.parse(value);
                  if (parsedValue <= 0) {
                    return 'Harga harus lebih besar dari 0';
                  }
                } catch (e) {
                  return 'Masukkan angka yang valid';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            Text(
              "Waktu Keberangkatan",
              style: TextStyles.poppinsBold(fontSize: 14),
            ),
            InkWell(
              onTap: () => _selectDateTime(context, true),
              child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color.fromRGBO(131, 180, 255, 1)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.black),
                      SizedBox(width: 8),
                      Text(
                        waktuKeberangkatan == null
                            ? "Pilih Waktu Keberangkatan"
                            : '${"${waktuKeberangkatan!.toLocal()}".split(' ')[0]} ${waktuKeberangkatan!.hour}:${waktuKeberangkatan!.minute}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  )),
            ),
            const SizedBox(height: 20),
            Text(
              "Waktu Kedatangan",
              style: TextStyles.poppinsBold(fontSize: 14),
            ),
            InkWell(
              onTap: () => _selectDateTime(context, false),
              child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color.fromRGBO(131, 180, 255, 1)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.black),
                      SizedBox(width: 8),
                      Text(
                        waktuKedatangan == null
                            ? "Pilih Waktu Kedatangan"
                            : '${"${waktuKedatangan!.toLocal()}".split(' ')[0]} ${waktuKedatangan!.hour}:${waktuKedatangan!.minute}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  )),
            ),
            const SizedBox(height: 20),
            Text(
              "Driver",
              style: TextStyles.poppinsBold(fontSize: 14),
            ),
            driverListener.when(
              data: (drivers) {
                return DropdownButtonFormField<Driver>(
                  value: selectedDriver,
                  items: [
                    DropdownMenuItem<Driver>(
                      value: null,
                      child: Text('Pilih Driver'),
                    ),
                    ...drivers.map((driver) {
                      return DropdownMenuItem<Driver>(
                        value: driver,
                        child: Text(driver.nama!),
                      );
                    }).toList(),
                  ],
                  onChanged: (Driver? newDriver) {
                    setState(() {
                      selectedDriver = newDriver;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Pilih Driver',
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Color.fromRGBO(131, 180, 255, 1)),
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
                    if (value == null) {
                      return 'Driver tidak boleh kosong';
                    }
                    return null;
                  },
                );
              },
              loading: () => CircularProgressIndicator(
                color: themeColor,
              ),
              error: (error, stack) => Text('Error: $error'),
            ),
            const SizedBox(height: 20),
            Text(
              "Kendaraan",
              style: TextStyles.poppinsBold(fontSize: 14),
            ),
            kendaraanListener.when(
              data: (kendaraans) {
                return DropdownButtonFormField<Kendaraan>(
                  value: selectedKendaraan,
                  items: [
                    DropdownMenuItem<Kendaraan>(
                      value: null,
                      child: Text('Pilih Kendaraan'),
                    ),
                    ...kendaraans.map((kendaraan) {
                      return DropdownMenuItem<Kendaraan>(
                        value: kendaraan,
                        child: Text('${kendaraan.plat} ( ${kendaraan.jenis!} )'),
                      );
                    }).toList(),
                  ],
                  onChanged: (Kendaraan? newKendaraan) {
                    setState(() {
                      selectedKendaraan = newKendaraan;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Pilih Kendaraan',
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Color.fromRGBO(131, 180, 255, 1)),
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
                    if (value == null) {
                      return 'Kendaraan tidak boleh kosong';
                    }
                    return null;
                  },
                );
              },
              loading: () => CircularProgressIndicator(
                color: themeColor,
              ),
              error: (error, stack) => Text('Error: $error'),
            ),
            const SizedBox(height: 30),
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
                  'Tambah Jadwal',
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
