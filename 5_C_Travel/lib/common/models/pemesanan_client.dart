import 'dart:convert';

import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tubes_5_c_travel/common/api/api_endpoints.dart';
import 'package:tubes_5_c_travel/common/models/pemesanan.dart';

class PemesananClient {
  //Untuk emulator//
  static final String url = ApiEndpoints.baseUrl;
  static final String endpoint = ApiEndpoints.pemesananEndpoint;

  //Untuk Android Biasa//
  // static final String url = '192.168.1.13';
  // static final String url = '10.53.7.128';
  // static final String endpoint = '5_C_Travel_API/public/api/pemesanan';

  // Mengambil token untuk user yang sedang login
  static Future<Map<String, String>> getAuthHeaders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    return {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };
  }

  static Future<List<Pemesanan>> fetchAll() async {
    try {
      var headers = await getAuthHeaders();
      var response = await get(
        Uri.https(url, '$endpoint/index'),
        headers: headers,
      );

      if (response.statusCode != 200) {
        throw Exception(response.reasonPhrase);
      }
      print(response.body);

      Iterable list = json.decode(response.body)['data'];
      return list.map((e) => Pemesanan.fromJson(e)).toList();
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<Response> create(Pemesanan pemesanan) async {
    try {
      var headers = await getAuthHeaders();

      String jsonn = pemesanan.toRawJson();
      print('Request Body: $jsonn');
      var response = await post(Uri.https(url, '$endpoint/create'),
          headers: headers, body: pemesanan.toRawJson());

      if (response.statusCode != 201) {
        throw Exception(response.reasonPhrase);
      }
      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<Pemesanan> fetchOne(int pemesananId) async {
    try {
      var headers = await getAuthHeaders();
      var response = await get(
        Uri.https(url, '$endpoint/show/$pemesananId'),
        headers: headers,
      );

      if (response.statusCode != 200) {
        throw Exception(response.reasonPhrase);
      }

      var dataResponse = json.decode(response.body)['data'];
      return Pemesanan.fromJson(dataResponse);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<Response> setSelesai(int pemesananId) async {
    try {
      var headers = await getAuthHeaders();
      var response = await post(
        Uri.https(url, '$endpoint/selesai/$pemesananId'),
        headers: headers,
      );

      if (response.statusCode != 200) {
        throw Exception(response.reasonPhrase);
      }

      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
