import 'dart:convert';

import 'package:client/core/constants/server_constant.dart';
import 'package:client/core/failure/failure.dart';
import 'package:client/features/auth/model/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_remote_repository.g.dart';

@riverpod
AuthRemoteRepository authRemoteRepository(Ref ref) {
  return AuthRemoteRepository();
}

// HTTP calls interacting with remote database server
class AuthRemoteRepository {
  // User Signup
  Future<Either<AppFailure, UserModel>> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(
          '${ServerConstant.serverUrl}/auth/signup',
        ),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          {
            'name': name,
            'email': email,
            'password': password,
          },
        ),
      );

      final resBodyMap = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 201) {
        // error
        return Left(
          AppFailure(
            resBodyMap["detail"],
          ),
        );
      } else {
        return Right(
          UserModel.fromMap(resBodyMap),
        );
      }
    } catch (e) {
      return Left(
        AppFailure(e.toString()),
      );
    }
  }

  // User login
  Future<Either<AppFailure, UserModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(
          '${ServerConstant.serverUrl}/auth/login',
        ),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
          {
            'email': email,
            'password': password,
          },
        ),
      );
      final resBodyMap = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200) {
        // error
        return Left(
          AppFailure(
            resBodyMap["detail"],
          ),
        );
      } else {
        return Right(
          UserModel.fromMap(resBodyMap['user']).copyWith(
            token: resBodyMap['token'],
          ),
        );
      }
    } catch (e) {
      return Left(
        AppFailure(e.toString()),
      );
    }
  }
}
