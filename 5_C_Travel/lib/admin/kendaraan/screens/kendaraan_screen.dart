import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tubes_5_c_travel/authentication/screens/login_screen.dart';
import 'package:tubes_5_c_travel/common/constants/fonts.dart';
import 'package:tubes_5_c_travel/common/constants/colors.dart';
import 'package:tubes_5_c_travel/admin/kendaraan/widgets/list_kendaraan.dart';
import 'package:tubes_5_c_travel/admin/kendaraan/screens/input_kendaraan.dart';
import 'package:tubes_5_c_travel/common/models/kendaraan.dart';
import 'package:tubes_5_c_travel/common/models/KendaraanClient.dart';
import 'package:tubes_5_c_travel/common/widgets/app_bar.dart';

final listKendaraanProvider = FutureProvider<List<Kendaraan>>((ref) async {
  return await KendaraanClient.fetchAll();
});

final filteredKendaraanProvider = StateProvider<List<Kendaraan>>((ref) => []);

class KendaraanScreen extends ConsumerWidget {
  const KendaraanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kendaraanListener = ref.watch(listKendaraanProvider);
    final filteredKendaraanList = ref.watch(filteredKendaraanProvider);

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: CustomAppBar(
            title: 'List Kendaraan',
            showLogoutIcon: true,
            onLogoutIconPressed: () {
              Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (_) => LoginScreen(),
                ),
                (_) => false,
              );
            },
          ),
          body: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                TextField(
                  onChanged: (query) {
                    kendaraanListener.whenData((driverList) {
                      final filteredList = driverList
                          .where((driver) => driver.jenis!
                              .toLowerCase()
                              .contains(query.toLowerCase()))
                          .toList();

                      ref.read(filteredKendaraanProvider.notifier).state =
                          filteredList;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Cari Kendaraan',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                const SizedBox(height: 12.0),
                Expanded(
                  child: kendaraanListener.when(
                    data: (kendaraanList) {
                      final listYangTampil = filteredKendaraanList.isEmpty
                          ? kendaraanList
                          : filteredKendaraanList;

                      return ListKendaraan(kendaraanList: listYangTampil);
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
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InputKendaraanScreen(),
                ),
              );

              if (result == true) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.green,
                    content: Text(
                      "Kendaraan berhasil ditambahkan!",
                      style: TextStyles.poppinsBold(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              }
            },
            backgroundColor: themeColor,
            child: Icon(
              Icons.add,
              color: Colors.white, // Ikon dengan warna putih
            ),
          ),
        ),
      ),
    );
  }
}