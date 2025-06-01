import 'dart:convert';
import 'package:http/http.dart';
import 'package:tubes_5_c_travel/common/api/api_endpoints.dart';
import 'package:tubes_5_c_travel/common/models/review_kendaraan.dart';

class ReviewKendaraanClient {
  //Untuk emulator//
  static final String url = ApiEndpoints.baseUrl;
  static final String endpoint = ApiEndpoints.reviewKendaraanEndpoint;

  //Untuk Android Biasa//
  // static final String url = '192.168.1.13';
  // static final String url = '10.53.7.128';
  // static final String endpoint = '5_C_Travel_API/public/api/kendaraan/review';

  static Future<List<ReviewKendaraan>> fetchAll(int kendaraanId) async {
    try {
      var response = await get(
        Uri.https(url, '$endpoint/index/$kendaraanId'),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode != 200) {
        throw Exception(response.reasonPhrase);
      }

      Iterable list = json.decode(response.body)['data'];
      return list.map((e) => ReviewKendaraan.fromJson(e)).toList();
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<Response> create(ReviewKendaraan reviewKendaraan) async {
    try {
      var response = await post(Uri.https(url, '$endpoint/create'),
          headers: {"Content-Type": "application/json"},
          body: reviewKendaraan.toRawJson());

      if (response.statusCode != 201) {
        throw Exception(response.reasonPhrase);
      }
      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
