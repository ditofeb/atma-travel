import 'dart:convert';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tubes_5_c_travel/common/api/api_endpoints.dart';
import 'package:tubes_5_c_travel/common/models/pembayaran.dart';

class PembayaranClient {
  static final String url = ApiEndpoints.baseUrl;
  static final String endpoint = ApiEndpoints.pembayaranEndpoint;

  static Future<Map<String, String>> getAuthHeaders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    return {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };
  }

  static Future<List<Pembayaran>> fetchAll() async {
    try {
      var response = await get(
        Uri.https(url, '$endpoint/index'),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode != 200) {
        throw Exception(response.reasonPhrase);
      }

      Iterable list = json.decode(response.body)['data'];
      return list.map((e) => Pembayaran.fromJson(e)).toList();
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<Response> create(Pembayaran pembayaran) async {
    try {
      var headers = await getAuthHeaders();
      String json = pembayaran.toRawJson();

      var response = await post(
        Uri.https(url, '$endpoint/create'),
        headers: headers,
        body: json,
      );

      if (response.statusCode != 201) {
        throw Exception(response.reasonPhrase);
      }
      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<Response> delete(id) async {
    try {
      var response = await delete(Uri.https(url, '$endpoint/delete/$id'));

      if (response.statusCode != 200) {
        throw Exception(response.reasonPhrase);
      }

      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
