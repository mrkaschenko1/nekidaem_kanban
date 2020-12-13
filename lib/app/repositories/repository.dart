import 'package:http/http.dart';

import '../services/api_service.dart';
import '../models/card_model.dart';

class Repository {
  var _token;
  final APIService _apiService;

  Repository(this._apiService);

  Future<String> tryLogin(String username, String password) async {
    try {
      _token = await _apiService.login(username: username, password: password);
    } on Response {
      rethrow;
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> refreshToken(String oldToken) async {
    try {
      _token = await _apiService.refreshToken(oldToken);
    } on Response {
      rethrow;
    } catch (e) {
      print(e.toString());
    }
  }

  void logout() {
    _token = null;
  }

  // Future<List<CardModel>> getCards() async {
  //   try {
  //     final cards = await _apiService.getCards(_token);
  //     return cards.map((key, value) => value.);
  //   } on Response {
  //     rethrow;
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }
}
