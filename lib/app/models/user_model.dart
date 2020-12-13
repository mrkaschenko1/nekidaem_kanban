import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class UserModel extends Equatable {
  final String username;
  final String password;
  final String token;

  UserModel({
    @required this.username,
    @required this.password,
    @required this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        username: json['username'] as String,
        password: json['password'] as String,
        token: json['token'] as String,
      );

  @override
  List<Object> get props => [username, password, token];
}
