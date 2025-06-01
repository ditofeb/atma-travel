import 'dart:io';

import 'package:tubes_5_c_travel/common/api/api_endpoints.dart';
import 'package:tubes_5_c_travel/common/models/User.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';
import 'package:http/http.dart';

class UserClient {
  //Untuk emulator//
  static final String url = ApiEndpoints.baseUrl;
  static final String endpoint = ApiEndpoints.userEndpoint;

  //Untuk Android Biasa//
  // static final String url = '192.168.1.13';
  // static final String url = '10.53.7.128';
  // static final String endpoint = '5_C_Travel_API/public/api/user';

  static Future<List<User>> fetchAll() async {
    try {
      var response = await get(
        Uri.https(url, '$endpoint/index'),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode != 200) {
        throw Exception(response.reasonPhrase);
      }

      Iterable list = json.decode(response.body)['data'];
      return list.map((e) => User.fromJson(e)).toList();
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<Response> register(User user) async {
    try {
      var response = await post(Uri.https(url, '$endpoint/register'),
          headers: {"Content-Type": "application/json"},
          body: user.toRawJson());

      if (response.statusCode != 201) {
        if (response.statusCode == 422) {
          var errorData = jsonDecode(response.body);

          if (errorData['message'].contains('username')) {
            return Future.error('Username sudah digunakan. Silakan coba dengan username yang berbeda.');
          }
          if (errorData['message'].contains('email')) {
            return Future.error('Email sudah terdaftar. Silakan gunakan email yang berbeda.');
          }

          return Future.error(errorData['message']);
        }
        throw Exception(response.reasonPhrase);
      }
      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<bool> login(User user) async {
    try {
      var response = await post(
        Uri.https(url, '$endpoint/login'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(
          {
            "username": user.username,
            "password": user.password,
          },
        ),
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        String token = responseData['token'];
        int userId = responseData['data']['id'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setInt('user_id', userId);

        return true;
      } else {
        if (response.statusCode == 401) {
          var errorData = jsonDecode(response.body);

          return Future.error(errorData['message']);
        }
        throw Exception(response.reasonPhrase);
      }
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

  static Future<User> getUserProfile() async {
    try {
      var headers = await getAuthHeaders();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? userId = prefs.getInt('user_id');

      if (userId == null) {
        throw Exception("ID User tidak ditemukan");
      }

      var response =
          await get(Uri.https(url, '$endpoint/show/$userId'), headers: headers);

      if (response.statusCode == 200) {
        return User.fromJson(json.decode(response.body)['data']);
      } else {
        throw Exception(response.reasonPhrase);
      }
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<Response> update(User user) async {
    try {
      var headers = await getAuthHeaders();
      var response = await put(Uri.https(url, '$endpoint/update'),
          headers: headers, body: user.toRawJson());

      if (response.statusCode != 200) {
        throw Exception(response.reasonPhrase);
      }
      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<Response> updateProfilePicture(File image) async {
    try {
      var headers = await getAuthHeaders();
      var request = MultipartRequest(
        'POST',
        Uri.https(url, '$endpoint/update/profilepicture'),
      );

      request.headers.addAll(headers);
      request.files.add(await MultipartFile.fromPath('image', image.path));

      var streamedResponse = await request.send();
      var response = await Response.fromStream(streamedResponse);

      if (response.statusCode != 200) {
        throw Exception(response.reasonPhrase);
      }
      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<bool> logout() async {
    try {
      var headers = await getAuthHeaders();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        return Future.error("Tidak ada User yang sedang login");
      }

      var response = await post(
        Uri.https(url, '$endpoint/logout'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        await prefs.remove('token');
        await prefs.remove('user_id');
        return true;
      } else {
        throw Exception(response.reasonPhrase);
      }
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<bool> deleteAccount() async {
    try {
      var headers = await getAuthHeaders();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        return Future.error("Tidak ada User yang sedang login");
      }

      var response = await delete(
        Uri.https(url, '$endpoint/delete'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        await prefs.remove('token');
        await prefs.remove('user_id');
        return true;
      } else {
        throw Exception(response.reasonPhrase);
      }
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
