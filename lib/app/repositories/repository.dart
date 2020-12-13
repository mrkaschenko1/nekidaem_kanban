import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nekidaem_kanban/app/exceptions/auth_exception.dart';
import 'package:nekidaem_kanban/app/models/user_model.dart';
import '../models/card_model.dart';
import 'package:http/http.dart' as http;
import 'api.dart';

class Repository {
  final API apiEndponts;
  final FlutterSecureStorage secureStorage;

  Repository({
    @required this.apiEndponts,
    @required this.secureStorage,
  });

  Future<String> tryLogin(
      {@required String username, @required String password}) async {
    final response = await http.post(
        apiEndponts.getEndpoint(Endpoint.login).toString(),
        body: {'username': username, 'password': password});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final token = data['token'];
      if (token != null) {
        await _updateToken(token);
        return token;
      }
    }
    throw response;
  }

  Future<List<CardModel>> getCards() async {
    var token = await this.token;
    var response = await http.get(
      apiEndponts.getEndpoint(Endpoint.cards).toString(),
      headers: {'Authorization': 'JWT $token'},
    );
    if (response.statusCode == 401) {
      token = await _refreshToken(token);
      response = await http.get(
        apiEndponts.getEndpoint(Endpoint.cards).toString(),
        headers: {'Authorization': 'JWT $token'},
      );
    }
    if (response.statusCode == 200) {
      final List<dynamic> cardsJson = json.decode(response.body) as List;
      if (cardsJson != null) {
        List<CardModel> cards =
            cardsJson.map((cardJson) => CardModel.fromJson(cardJson)).toList();
        return cards;
      }
    }
    print('''
      Request ${apiEndponts.getEndpoint(Endpoint.cards)} failed\n
      Response: ${response.statusCode} ${response.reasonPhrase}
    ''');
    throw response;
  }

  Future<String> _refreshToken(String oldToken) async {
    var response = await http.post(
      apiEndponts.getEndpoint(Endpoint.refresh_token).toString(),
      body: {"token": oldToken},
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final newToken = data['token'];
      if (newToken != null) {
        await this._updateToken(newToken);
        return newToken;
      }
    }
    print('''
      Request ${apiEndponts.getEndpoint(Endpoint.refresh_token)} failed\n
      Response: ${response.statusCode} ${response.reasonPhrase}
    ''');
    throw response;
  }

  Future<void> logout() async {
    await _deleteUser();
  }

  Future<String> get token async {
    if (await this.secureStorage.containsKey(key: "token")) {
      return this.secureStorage.read(key: "token");
    } else {
      throw AuthException('No token stored');
    }
  }

  Future<UserModel> get currentUser async {
    if (await this.secureStorage.containsKey(key: "token") &&
        await this.secureStorage.containsKey(key: "username") &&
        await this.secureStorage.containsKey(key: "password")) {
      final username = await this.secureStorage.read(key: "username");
      final password = await this.secureStorage.read(key: "password");
      final token = await this.secureStorage.read(key: "token");

      return UserModel(username: username, password: password, token: token);
    } else {
      throw AuthException('No user stored');
    }
  }

  Future<void> _setUser(UserModel user) async {
    await this.secureStorage.write(key: "username", value: user.username);
    await this.secureStorage.write(key: "password", value: user.password);
    await this.secureStorage.write(key: "token", value: user.token);
  }

  Future<void> _deleteUser() async {
    await this.secureStorage.delete(key: "username");
    await this.secureStorage.delete(key: "password");
    await this.secureStorage.delete(key: "token");
  }

  Future<void> _updateToken(String token) async {
    await this.secureStorage.write(key: "token", value: token);
  }
}
