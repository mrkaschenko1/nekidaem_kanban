import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'api.dart';
import 'package:http/http.dart' as http;

class APIService {
  APIService(this.api);
  final API api;

  Future<String> login(
      {@required String username, @required String password}) async {
    final response = await http.post(api.getEndpoint(Endpoint.login).toString(),
        body: {'username': username, 'password': password});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final token = data['token'];
      if (token != null) {
        return token;
      }
    }
    throw response;
  }

  Future<Map<String, dynamic>> getCards(String token) async {
    var response = await http.get(
      api.getEndpoint(Endpoint.cards).toString(),
      headers: {'Authorization': 'JWT $token'},
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data != null) {
        return data;
      }
    }
    print('''
      Request ${api.getEndpoint(Endpoint.cards)} failed\n
      Response: ${response.statusCode} ${response.reasonPhrase}
    ''');
    throw response;
  }

  Future<String> refreshToken(String oldToken) async {
    var response = await http.post(
      api.getEndpoint(Endpoint.refresh_token).toString(),
      body: {"token": oldToken},
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final newToken = data['token'];
      if (newToken != null) {
        return newToken;
      }
    }
    print('''
      Request ${api.getEndpoint(Endpoint.refresh_token)} failed\n
      Response: ${response.statusCode} ${response.reasonPhrase}
    ''');
    throw response;
  }

  // Future<EndpointData> getEndpointData({
  //   @required String token,
  //   @required Endpoint endpoint,
  // }) async {
  //   final uri = api.endpointUri(endpoint);
  //   final response = await http.get(
  //     uri.toString(),
  //     headers: {'Authorization': 'JWT $accessToken'},
  //   );
  //   if (response.statusCode == 200) {
  //     final List<dynamic> data = json.decode(response.body);
  //     if (data.isNotEmpty) {
  //       final Map<String, dynamic> endpointData = data[0];
  //       final String responseJsonKey = _responseJsonKeys[endpoint];
  //       final int value = endpointData[responseJsonKey];
  //       final String dateString = endpointData['date'];
  //       final date = DateTime.tryParse(dateString);
  //       if (value != null) {
  //         return EndpointData(value: value, date: date);
  //       }
  //     }
  //   }
  //   print(
  //       'Request $uri failed\nResponse: ${response.statusCode} ${response.reasonPhrase}');
  //   throw response;
  // }

  // static Map<Endpoint, List<String>> _responseJsonKeys = {
  //   Endpoint.login: 'cases',
  //   Endpoint.cards: '',
  //   Endpoint.refresh_token: 'data',
  // };
}
