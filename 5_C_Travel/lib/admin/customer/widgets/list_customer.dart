import 'package:flutter/material.dart';
import 'package:tubes_5_c_travel/common/models/User.dart';
import 'package:tubes_5_c_travel/admin/customer/screens/detail_customer.dart';
import 'package:tubes_5_c_travel/common/constants/colors.dart';
import 'package:tubes_5_c_travel/common/constants/fonts.dart';

class ListCustomer extends StatelessWidget {
  final List<User> customerList;

  const ListCustomer({super.key, required this.customerList});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: customerList.length,
      itemBuilder: (context, index) {
        final customer = customerList[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 5,
          shadowColor: Colors.black.withOpacity(0.3),
          color: const Color.fromRGBO(231, 240, 255, 1), // Warna biru muda
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 107,
                    width: 107,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: customer.imageUrl != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              customer.imageUrl!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Center(
                            child: Icon(
                              Icons.person,
                              size: 50,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        customer.username!,
                        style: TextStyles.poppinsBold(
                            fontSize: 20, color: Colors.black),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        customer.email!,
                        style: TextStyles.poppinsNormal(
                            fontSize: 14, color: Colors.black),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            customer.nomorTelp!,
                            style: TextStyles.poppinsNormal(
                                fontSize: 14, color: Colors.black),
                          ),
                          Expanded(
                            child: SizedBox(),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DetailCustomer(customer: customer),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: themeColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Review',
                              style: TextStyles.poppinsBold(
                                  fontSize: 14, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
