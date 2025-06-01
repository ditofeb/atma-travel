import 'package:flutter/material.dart';
import 'package:tubes_5_c_travel/common/constants/fonts.dart';
import 'package:tubes_5_c_travel/common/models/review_driver.dart';

class ListReviewDriver extends StatelessWidget {
  final List<ReviewDriver> reviewList;

  const ListReviewDriver({super.key, required this.reviewList});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: reviewList.length,
      itemBuilder: (context, index) {
        final review = reviewList[index];
        return Container(
          margin: EdgeInsets.symmetric(vertical: 8),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        'ID ${review.idPemesanan}',
                        style: TextStyles.poppinsBold(fontSize: 15),
                      ),
                      SizedBox(width: 8),
                      Text(
                        '•',
                        style: TextStyles.poppinsBold(fontSize: 15),
                      ),
                      SizedBox(width: 8),
                      Text(
                        '${review.username}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      SizedBox(width: 4),
                      Text(
                        '${review.rating}',
                        style: TextStyles.poppinsBold(fontSize: 15),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                review.komentar!,
                style: TextStyles.poppinsNormal(fontSize: 15),
              ),
            ],
          ),
        );
      },
    );
  }
}
