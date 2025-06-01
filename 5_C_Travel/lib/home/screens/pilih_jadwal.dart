import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tubes_5_c_travel/admin/jadwal/screens/input_jadwal_screen.dart';
import 'package:tubes_5_c_travel/authentication/screens/login_screen.dart';
import 'package:tubes_5_c_travel/common/constants/colors.dart';
import 'package:tubes_5_c_travel/pemesanan/widgets/list_pilih_jadwal.dart';
import 'package:tubes_5_c_travel/common/constants/fonts.dart';
import 'package:tubes_5_c_travel/common/models/JadwalClient.dart';
import 'package:tubes_5_c_travel/common/models/jadwal.dart';
import 'package:tubes_5_c_travel/common/widgets/app_bar.dart';

final listJadwalProvider = FutureProvider<List<Jadwal>>((ref) async {
  return await JadwalClient.fetchAll();
});

final filteredJadwalProvider = StateProvider<List<Jadwal>>((ref) => []);

class PilihJadwal extends ConsumerWidget {
  final String fromLocation;
  final String toLocation;
  final DateTime selectedDate;
  final int passengerCount;

  const PilihJadwal({
    super.key,
    required this.fromLocation,
    required this.toLocation,
    required this.selectedDate,
    required this.passengerCount,
  });

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
            title: 'Pilih Jadwal Travel',
            showLeadingIcon: true,
            onLeadingIconPressed: () {
              Navigator.pop(context);
            },
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              ref.refresh(listJadwalProvider);
            },
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Expanded(
                    child: jadwalListener.when(
                      data: (jadwalList) {
                        final filteredList = jadwalList.where((jadwal) {
                          bool matchesTitikKeberangkatan = jadwal
                              .titikKeberangkatan!
                              .toLowerCase()
                              .contains(fromLocation.toLowerCase());
                          bool matchesTitikKedatangan = jadwal.titikKedatangan!
                              .toLowerCase()
                              .contains(toLocation.toLowerCase());
                          bool matchesTanggal = jadwal.waktuKeberangkatan !=
                                  null &&
                              jadwal.waktuKeberangkatan!.year >=
                                  selectedDate.year &&
                              jadwal.waktuKeberangkatan!.month >=
                                  selectedDate.month &&
                              jadwal.waktuKeberangkatan!.day >= selectedDate.day;
            
                          bool matchesJumlahPenumpang =
                              (jadwal.sisaVIP! + jadwal.sisaReguler!) >=
                                  passengerCount;
            
                          return matchesTitikKeberangkatan &&
                              matchesTitikKedatangan &&
                              matchesTanggal &&
                              matchesJumlahPenumpang;
                        }).toList();
            
                        if (filteredList.isEmpty) {
                          return Center(
                            child: Text(
                              'Tidak ada jadwal yang tersedia',
                              style: TextStyles.poppinsNormal(fontSize: 15),
                            ),
                          );
                        }
            
                        return ListPilihJadwal(
                            jadwalList: filteredList,
                            passengerCount: passengerCount);
                      },
                      error: (err, s) => Center(
                        child: Text('Error: $err'),
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
          ),
        ),
      ),
    );
  }
}
