import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tubes_5_c_travel/admin/jadwal/screens/input_jadwal_screen.dart';
import 'package:tubes_5_c_travel/authentication/screens/login_screen.dart';
import 'package:tubes_5_c_travel/common/constants/colors.dart';
import 'package:tubes_5_c_travel/admin/jadwal/widgets/list_jadwal.dart';
import 'package:tubes_5_c_travel/common/constants/fonts.dart';
import 'package:tubes_5_c_travel/common/models/JadwalClient.dart';
import 'package:tubes_5_c_travel/common/models/jadwal.dart';
import 'package:tubes_5_c_travel/common/widgets/app_bar.dart';

final listJadwalProvider = FutureProvider<List<Jadwal>>((ref) async {
  return await JadwalClient.fetchAll();
});

final filteredJadwalProvider = StateProvider<List<Jadwal>>((ref) => []);

class JadwalScreen extends ConsumerWidget {
  const JadwalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jadwalListener = ref.watch(listJadwalProvider);
    final filteredJadwalList = ref.watch(filteredJadwalProvider);

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: CustomAppBar(
            title: 'Jadwal Atma Travel',
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
                    jadwalListener.whenData((jadwalList) {
                      final filteredList = jadwalList.where((jadwal) {
                        bool matchesTitikKeberangkatan = jadwal
                            .titikKeberangkatan!
                            .toLowerCase()
                            .contains(query.toLowerCase());
                        bool matchesTitikKedatangan = jadwal
                            .titikKedatangan!
                            .toLowerCase()
                            .contains(query.toLowerCase());
                        bool matchesNamaDriver = jadwal.driver!.nama!
                            .toLowerCase()
                            .contains(query.toLowerCase());
                        bool matchesJenisKendaraan = jadwal
                            .kendaraan!.jenis!
                            .toLowerCase()
                            .contains(query.toLowerCase());

                        return matchesTitikKeberangkatan ||
                            matchesTitikKedatangan ||
                            matchesNamaDriver ||
                            matchesJenisKendaraan;
                      }).toList();

                      ref.read(filteredJadwalProvider.notifier).state =
                          filteredList;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Cari Jadwal',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                const SizedBox(height: 12.0),
                Expanded(
                  child: jadwalListener.when(
                    data: (jadwalList) {
                      final listYangTampil = filteredJadwalList.isEmpty
                          ? jadwalList
                          : filteredJadwalList;

                      return ListJadwal(jadwalList: listYangTampil);
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
                  builder: (context) => InputJadwalScreen(),
                ),
              );

              if (result == true) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.green,
                    content: Text(
                      "Jadwal berhasil ditambahkan!",
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
              color: Colors.white, // Warna ikon putih
            ),
          ),
        ),
      ),
    );
  }
}