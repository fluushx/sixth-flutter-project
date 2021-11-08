import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthService extends ChangeNotifier {
  final String _baseUrl = "identitytoolkit.googleapis.com";
  final String _firebaseToken = "AIzaSyDiIL1HtqxycI6ul0vS52dMW-OGQGLSQnY";

  Future<String?> createUser(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
    };
    final url =
        Uri.https(_baseUrl, '/v1/accounts:signUp', {'key': _firebaseToken});

    final resp = await http.post(url, body: json.encode(authData));
    final Map<String, dynamic> decodeResp = json.decode(resp.body);
    if (decodeResp.containsKey('idToken')) {
      //token guardado
    } else {
      return decodeResp['error']['message'];
    }
  }

  Future<String?> loginUser(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
    };
    final url = Uri.https(
        _baseUrl, '/v1/accounts:signInWithPassword', {'key': _firebaseToken});

    final resp = await http.post(url, body: json.encode(authData));
    final Map<String, dynamic> decodeResp = json.decode(resp.body);
    print(decodeResp);
    if (decodeResp.containsKey('idToken')) {
      //token guardado
    } else {
      return decodeResp['error']['message'];
    }
  }
}
