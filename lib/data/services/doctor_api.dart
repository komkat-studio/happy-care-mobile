import 'dart:async';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class DoctorApi {
  Future<String> getDoctorMaybeBySpecId(
      {required String token, String? specId}) async {
    Map<String, String> headers = {'Authorization': 'Bearer $token'};
    String path = specId == null
        ? "/api/users/get-doctors"
        : "/api/users/get-doctors?specId=$specId";
    var response = await http
        .get(
            // Uri.parse("${dotenv.env['BASE_URL']}$path"),
            Uri.parse("${dotenv.env['DEV_URL']}$path"),
            headers: headers)
        .timeout(Duration(minutes: 2), onTimeout: () {
      throw TimeoutException("Time out exception");
    });
    if (response.statusCode == 200) {
      print("=======GET_DOCTOR_BY_SPEC======\n" + response.body);
      return response.body;
    } else {
      throw Exception();
    }
  }
}