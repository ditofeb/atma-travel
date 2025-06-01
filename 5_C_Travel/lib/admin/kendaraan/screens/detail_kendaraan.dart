import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tubes_5_c_travel/admin/kendaraan/widgets/list_reviewKendaraan.dart';
import 'package:tubes_5_c_travel/common/constants/fonts.dart';
import 'package:tubes_5_c_travel/common/constants/colors.dart';
import 'package:tubes_5_c_travel/common/models/kendaraan.dart';
import 'package:tubes_5_c_travel/common/models/review_kendaraan.dart';
import 'package:tubes_5_c_travel/common/models/review_kendaraanClient.dart';
import 'package:tubes_5_c_travel/common/widgets/app_bar.dart';
import 'package:tubes_5_c_travel/common/widgets/chart_review.dart';

final listReviewKendaraanProvider =
    FutureProvider.family<List<ReviewKendaraan>, int>((ref, kendaraanId) async {
  return await ReviewKendaraanClient.fetchAll(kendaraanId);
});

class DetailKendaraan extends ConsumerWidget {
  final Kendaraan kendaraan;

  const DetailKendaraan({super.key, required this.kendaraan});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviewKendaraanListener =
        ref.watch(listReviewKendaraanProvider(kendaraan.id!));

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: CustomAppBar(
            title: 'Detail Kendaraan',
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
                      backgroundColor: Colors.grey[300],
                      child: Container(
                        height: 107,
                        width: 107,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            kendaraan.picture!,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            kendaraan.jenis!,
                            style: TextStyles.poppinsBold(
                                fontSize: 18, color: Colors.black),
                          ),
                          SizedBox(height: 4),
                          Text(
                            kendaraan.plat!,
                            style: TextStyles.poppinsNormal(
                                fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 20),
                        SizedBox(width: 5),
                        Text(
                          kendaraan.totalRating?.toStringAsFixed(1) ?? 'N/A',
                          style: TextStyles.poppinsBold(
                              fontSize: 20, color: Colors.black),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Icon(Icons.group, color: themeColor, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Maks. ${kendaraan.kapasitas} Orang',
                      style: TextStyles.poppinsNormal(fontSize: 15),
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
                ChartReview(listRating: kendaraan.ratingBulanan!),
                SizedBox(height: 16),
                Text(
                  'Reviews',
                  style: TextStyles.poppinsBold(
                      fontSize: 18, color: Colors.black87),
                ),
                Expanded(
                  child: reviewKendaraanListener.when(
                    data: (reviewKendaraanList) {
                      return ListReviewKendaraan(
                          reviewList: reviewKendaraanList);
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
