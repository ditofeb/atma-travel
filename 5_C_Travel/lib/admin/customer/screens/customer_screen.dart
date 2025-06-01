import 'package:flutter/material.dart';
import 'package:tubes_5_c_travel/authentication/screens/login_screen.dart';
import 'package:tubes_5_c_travel/common/constants/colors.dart';
import 'package:tubes_5_c_travel/admin/customer/widgets/list_customer.dart';
import 'package:tubes_5_c_travel/common/models/User.dart';
import 'package:tubes_5_c_travel/common/models/UserClient.dart';
import 'package:tubes_5_c_travel/common/widgets/app_bar.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final listUserProvider = FutureProvider<List<User>>((ref) async {
  return await UserClient.fetchAll();
});

final filteredUserProvider = StateProvider<List<User>>((ref) => []);

class CustomerScreen extends ConsumerWidget {
  const CustomerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userListener = ref.watch(listUserProvider);
    final filteredCustomerList = ref.watch(filteredUserProvider);

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: CustomAppBar(
            title: 'List Customer',
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
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                TextField(
                  onChanged: (query) {
                    userListener.whenData((customerList) {
                      final filteredList = customerList
                          .where((customer) => customer.username!
                              .toLowerCase()
                              .contains(query.toLowerCase()))
                          .toList();

                      ref.read(filteredUserProvider.notifier).state =
                          filteredList;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Cari Customer',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                const SizedBox(height: 12.0),
                Expanded(
                  child: userListener.when(
                    data: (customerList) {
                      final listYangTampil = filteredCustomerList.isEmpty
                          ? customerList
                          : filteredCustomerList;

                      return ListCustomer(customerList: listYangTampil);
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
    );
  }
}
