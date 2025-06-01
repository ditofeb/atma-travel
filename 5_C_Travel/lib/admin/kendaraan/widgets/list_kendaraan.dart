import 'package:flutter/material.dart';
import 'package:tubes_5_c_travel/common/constants/colors.dart';
import 'package:tubes_5_c_travel/common/models/kendaraan.dart';
import 'package:tubes_5_c_travel/common/constants/fonts.dart';
import 'package:tubes_5_c_travel/admin/kendaraan/screens/detail_kendaraan.dart';

class ListKendaraan extends StatelessWidget {
  final List<Kendaraan> kendaraanList;

  const ListKendaraan({super.key, required this.kendaraanList});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: kendaraanList.length,
      itemBuilder: (context, index) {
        final kendaraan = kendaraanList[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 5,
          shadowColor: Colors.black.withOpacity(0.3),
          color: Color.fromRGBO(231, 240, 255, 1),
          child: Padding(
            padding: EdgeInsets.all(20),
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
                      kendaraan.picture!,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            kendaraan.jenis!,
                            style: TextStyles.poppinsBold(
                                fontSize: 16, color: Colors.black),
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
                                kendaraan.totalRating?.toStringAsFixed(1) ??
                                    'N/A',
                                style: TextStyles.poppinsNormal(
                                    fontSize: 14, color: Colors.black),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Text(
                        kendaraan.plat!,
                        style: TextStyles.poppinsNormal(
                            fontSize: 14, color: Colors.black),
                      ),
                      SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailKendaraan(kendaraan: kendaraan),
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
