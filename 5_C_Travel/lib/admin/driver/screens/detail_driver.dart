import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tubes_5_c_travel/common/widgets/chart_review.dart';
import 'package:tubes_5_c_travel/admin/driver/widgets/list_reviewDriver.dart';
import 'package:tubes_5_c_travel/common/constants/colors.dart';
import 'package:tubes_5_c_travel/common/constants/fonts.dart';
import 'package:tubes_5_c_travel/common/models/Driver.dart';
import 'package:tubes_5_c_travel/common/models/review_driver.dart';
import 'package:tubes_5_c_travel/common/models/review_driverClient.dart';
import 'package:tubes_5_c_travel/common/widgets/app_bar.dart';

final listReviewDriverProvider =
    FutureProvider.family<List<ReviewDriver>, int>((ref, driverId) async {
  return await ReviewDriverClient.fetchAll(driverId);
});

class DetailDriver extends ConsumerWidget {
  final Driver driver;

  const DetailDriver({super.key, required this.driver});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviewDriverListener =
        ref.watch(listReviewDriverProvider(driver.id!));

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: CustomAppBar(
            title: 'Detail Driver',
            showLeadingIcon: true,
            onLeadingIconPressed: () {
              Navigator.pop(context);
            },
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('assets/images/driver.png'),
                      // backgroundColor: Colors.white,
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            driver.nama!,
                            style: TextStyles.poppinsBold(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Driver ${driver.id}',
                            style: TextStyles.poppinsNormal(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.calendar_today,
                                      size: 16, color: Colors.black),
                                  const SizedBox(
                                    width: 5.0,
                                  ),
                                  Text(
                                    driver.tanggalLahir != null
                                        ? DateFormat('dd-MM-yyyy')
                                            .format(driver.tanggalLahir!)
                                        : 'N/A',
                                    style: TextStyles.poppinsNormal(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 20),
                              Row(
                                children: [
                                  Icon(Icons.phone,
                                      size: 16, color: Colors.black),
                                  const SizedBox(
                                    width: 5.0,
                                  ),
                                  Text(
                                    driver.nomorTelp!,
                                    style: TextStyles.poppinsNormal(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 20),
                        SizedBox(width: 5),
                        Text(
                          driver.totalRating?.toStringAsFixed(1) ?? 'N/A',
                          style: TextStyles.poppinsBold(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Divider(thickness: 1, color: Colors.grey[300]),
                SizedBox(height: 16),
                Text(
                  'Review Statistics',
                  style: TextStyles.poppinsBold(
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
                ChartReview(listRating: driver.ratingBulanan!),
                SizedBox(height: 16),
                Text(
                  'Reviews',
                  style: TextStyles.poppinsBold(
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
                Expanded(
                  child: reviewDriverListener.when(
                    data: (reviewDriverList) {
                      return ListReviewDriver(reviewList: reviewDriverList);
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
