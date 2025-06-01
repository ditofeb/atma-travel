import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tubes_5_c_travel/authentication/screens/login_screen.dart';
import 'package:tubes_5_c_travel/common/constants/colors.dart';
import 'package:tubes_5_c_travel/admin/driver/widgets/list_driver.dart';
import 'package:tubes_5_c_travel/admin/driver/screens/input_driver.dart';
import 'package:tubes_5_c_travel/common/constants/fonts.dart';
import 'package:tubes_5_c_travel/common/models/DriverClient.dart';
import 'package:tubes_5_c_travel/common/models/Driver.dart';
import 'package:tubes_5_c_travel/common/widgets/app_bar.dart';

final listDriverProvider = FutureProvider<List<Driver>>((ref) async {
  return await DriverClient.fetchAll();
});

final filteredDriverProvider = StateProvider<List<Driver>>((ref) => []);

class DriverScreen extends ConsumerWidget {
  const DriverScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final driverListener = ref.watch(listDriverProvider);
    final filteredDriverList = ref.watch(filteredDriverProvider);

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: CustomAppBar(
            title: 'List Driver',
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
                    driverListener.whenData((driverList) {
                      final filteredList = driverList
                          .where((driver) => driver.nama!
                              .toLowerCase()
                              .contains(query.toLowerCase()))
                          .toList();

                      ref.read(filteredDriverProvider.notifier).state =
                          filteredList;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Cari Driver',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                const SizedBox(height: 12.0),
                Expanded(
                  child: driverListener.when(
                    data: (driverList) {
                      final listYangTampil = filteredDriverList.isEmpty
                          ? driverList
                          : filteredDriverList;

                      return ListDriver(driverList: listYangTampil);
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
                  builder: (context) => InputDriverScreen(),
                ),
              );

              if (result == true) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.green,
                    content: Text(
                      "Driver berhasil ditambahkan!",
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
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
