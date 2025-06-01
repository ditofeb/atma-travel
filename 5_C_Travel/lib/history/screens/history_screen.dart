import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tubes_5_c_travel/common/constants/colors.dart';
import 'package:tubes_5_c_travel/common/constants/fonts.dart';
import 'package:tubes_5_c_travel/common/models/pemesanan_client.dart';
import 'package:tubes_5_c_travel/common/widgets/app_bar.dart';
import 'package:tubes_5_c_travel/common/models/pemesanan.dart';
import 'package:tubes_5_c_travel/history/widgets/list_pemesanan.dart';

final listPemesananProvider = FutureProvider<List<Pemesanan>>((ref) async {
  return await PemesananClient.fetchAll();
});

final filteredPemesananProvider = StateProvider<List<Pemesanan>>((ref) => []);

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  bool isOngoingSelected = false;

  @override
  void initState() {
    super.initState();
    // setFilterToSelesai();
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   setFilterToSelesai();
  // }

  Future<void> setFilterToSelesai() async {
    setState(() {
      isOngoingSelected = false;
      ref.read(listPemesananProvider).whenData((pemesananList) {
        final filteredList = pemesananList.where((pemesanan) {
          bool isSelesai =
              pemesanan.statusPemesanan!.toLowerCase().contains('selesai');
          return isSelesai;
        }).toList();

        ref.read(filteredPemesananProvider.notifier).state = filteredList;
      });
    });
  }

  Future<void> setFilterToOngoing() async {
    setState(() {
      isOngoingSelected = true;
      ref.read(listPemesananProvider).whenData((pemesananList) {
        final filteredList = pemesananList.where((pemesanan) {
          bool isOngoing =
              pemesanan.statusPemesanan!.toLowerCase().contains('ongoing');
          return isOngoing;
        }).toList();

        ref.read(filteredPemesananProvider.notifier).state = filteredList;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final pemesananListener = ref.watch(listPemesananProvider);
    final filteredPemesananList = ref.watch(filteredPemesananProvider);

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: CustomAppBar(
            title: 'History',
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              ref.refresh(listPemesananProvider);
              if (isOngoingSelected) {
                await setFilterToOngoing();
              } else {
                await setFilterToSelesai();
              }
              return;
            },
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: setFilterToSelesai,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            backgroundColor:
                                isOngoingSelected ? Colors.white : themeColor,
                          ),
                          child: Text(
                            'Selesai',
                            style: TextStyles.poppinsBold(
                                fontSize: 15,
                                color: isOngoingSelected
                                    ? Colors.black
                                    : Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 12.0,
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isOngoingSelected = true;
                              pemesananListener.whenData((pemesananList) {
                                final filteredList =
                                    pemesananList.where((pemesanan) {
                                  bool isOngoing = pemesanan.statusPemesanan!
                                      .toLowerCase()
                                      .contains('ongoing');

                                  return isOngoing;
                                }).toList();

                                ref
                                    .read(filteredPemesananProvider.notifier)
                                    .state = filteredList;
                              });
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            backgroundColor:
                                isOngoingSelected ? themeColor : Colors.white,
                          ),
                          child: Text(
                            'Ongoing',
                            style: TextStyles.poppinsBold(
                                fontSize: 15,
                                color: isOngoingSelected
                                    ? Colors.white
                                    : Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Expanded(
                    child: pemesananListener.when(
                      data: (pemesananList) {
                        if (filteredPemesananList.isEmpty) {
                          setFilterToSelesai();
                        }
                        return ListPemesanan(
                          pemesananList: filteredPemesananList,
                          onFilterChange: setFilterToSelesai,
                        );
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
          ),
        ),
      ),
    );
  }
}
