import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:tubes_5_c_travel/common/api/api_endpoints.dart';
import 'package:tubes_5_c_travel/common/models/kendaraan.dart';

class KendaraanClient {
  //Untuk emulator//
  static final String url = ApiEndpoints.baseUrl;
  static final String endpoint = ApiEndpoints.kendaraanEndpoint;

  //Untuk Android Biasa//
  // static final String url = '192.168.1.13';
  // static final String url = '10.53.7.128';
  // static final String endpoint = '5_C_Travel_API/public/api/kendaraan';

  static Future<List<Kendaraan>> fetchAll() async {
    try {
      var response = await get(
        Uri.https(url, '$endpoint/index'),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode != 200) {
        throw Exception(response.reasonPhrase);
      }

      Iterable list = json.decode(response.body)['data'];
      return list.map((e) => Kendaraan.fromJson(e)).toList();
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<Response> create(Kendaraan kendaraan) async {
    try {
      String jsonn = kendaraan.toRawJson();
      print('Request Body: $jsonn');
      var response = await post(Uri.https(url, '$endpoint/create'),
          headers: {"Content-Type": "application/json"},
          body: kendaraan.toRawJson());

      if (response.statusCode != 201) {
        throw Exception(response.reasonPhrase);
      }
      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  // Mengambil token untuk user yang sedang login
  static Future<Map<String, String>> getAuthHeaders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    return {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };
  }

  static Future<Kendaraan> getKendaraan(int kendaraanId) async {
    try {
      var headers = await getAuthHeaders();

      var response = await get(Uri.https(url, '$endpoint/show/$kendaraanId'),
          headers: headers);

      if (response.statusCode == 200) {
        return Kendaraan.fromJson(json.decode(response.body)['data']);
      } else {
        throw Exception(response.reasonPhrase);
      }
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
