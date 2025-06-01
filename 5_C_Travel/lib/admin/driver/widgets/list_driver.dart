import 'package:flutter/material.dart';
import 'package:tubes_5_c_travel/common/models/Driver.dart';
import 'package:tubes_5_c_travel/admin/driver/screens/detail_driver.dart';
import 'package:tubes_5_c_travel/common/constants/colors.dart';
import 'package:tubes_5_c_travel/common/constants/fonts.dart';

class ListDriver extends StatelessWidget {
  final List<Driver> driverList;

  const ListDriver({super.key, required this.driverList});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: driverList.length,
      itemBuilder: (context, index) {
        final driver = driverList[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 5,
          shadowColor: Colors.black.withOpacity(0.3),
          color: Color.fromRGBO(231, 240, 255, 1),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  height: 107,
                  width: 107,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/images/driver.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        driver.nama!,
                        style: TextStyles.poppinsBold(fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Driver ${driver.id}',
                            style: TextStyles.poppinsNormal(fontSize: 14),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 20,
                              ),
                              SizedBox(width: 5),
                              Text(
                                driver.totalRating?.toStringAsFixed(1) ?? 'N/A',
                                style: TextStyles.poppinsNormal(fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailDriver(driver: driver),
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
                          'See Review',
                          style: TextStyles.poppinsBold(
                              fontSize: 14, color: Colors.white),
                        ),
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
