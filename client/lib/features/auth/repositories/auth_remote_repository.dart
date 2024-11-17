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
  // Provides an instance of the AuthRemoteRepository for dependency injection
  return AuthRemoteRepository();
}

// Class to handle authentication-related HTTP calls interacting with the remote server
class AuthRemoteRepository {
  // User Signup
  Future<Either<AppFailure, UserModel>> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      // Sends a POST request to the signup endpoint
      final response = await http.post(
        Uri.parse(
          '${ServerConstant.serverUrl}/auth/signup', // Server endpoint for user signup
        ),
        headers: {
          'Content-Type':
              'application/json', // Specifies the request format as JSON
        },
        body: jsonEncode(
          {
            'name': name, // User's name
            'email': email, // User's email address
            'password': password, // User's password
          },
        ),
      );

      // Decode the JSON response body into a Map
      final resBodyMap = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 201) {
        // If status is not 201 (created), return an error with the detail from the response
        return Left(
          AppFailure(
            resBodyMap["detail"], // Error message from the server
          ),
        );
      } else {
        // On success, return a UserModel created from the response data
        return Right(
          UserModel.fromMap(resBodyMap),
        );
      }
    } catch (e) {
      // Catch and return any unexpected exceptions as an AppFailure
      return Left(
        AppFailure(e.toString()),
      );
    }
  }

  // User Login
  Future<Either<AppFailure, UserModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      // Sends a POST request to the login endpoint
      final response = await http.post(
        Uri.parse(
          '${ServerConstant.serverUrl}/auth/login', // Server endpoint for user login
        ),
        headers: {'Content-Type': 'application/json'}, // Request format as JSON
        body: jsonEncode(
          {
            'email': email, // User's email address
            'password': password, // User's password
          },
        ),
      );

      // Decode the JSON response body into a Map
      final resBodyMap = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200) {
        // If status is not 200 (OK), return an error with the detail from the response
        return Left(
          AppFailure(
            resBodyMap["detail"], // Error message from the server
          ),
        );
      } else {
        // On success, return a UserModel with the token included
        return Right(
          UserModel.fromMap(resBodyMap['user']).copyWith(
            token: resBodyMap['token'], // Include the received token
          ),
        );
      }
    } catch (e) {
      // Catch and return any unexpected exceptions as an AppFailure
      return Left(
        AppFailure(e.toString()),
      );
    }
  }

  // Fetch Current User Data
  Future<Either<AppFailure, UserModel>> getCurrentUserData(
    String token,
  ) async {
    try {
      // Sends a GET request to fetch the current user's data
      final response = await http.get(
        Uri.parse(
          '${ServerConstant.serverUrl}/auth/', // Server endpoint for fetching user data
        ),
        headers: {
          'Content-Type':
              'application/json', // Specifies the request format as JSON
          'x-auth-token': token, // Pass the authentication token in headers
        },
      );

      // Decode the JSON response body into a Map
      final resBodyMap = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200) {
        // If status is not 200 (OK), return an error with the detail from the response
        return Left(
          AppFailure(
            resBodyMap["detail"], // Error message from the server
          ),
        );
      } else {
        // On success, return a UserModel with the token included
        return Right(
          UserModel.fromMap(resBodyMap).copyWith(
            token: token, // Include the token
          ),
        );
      }
    } catch (e) {
      // Catch and return any unexpected exceptions as an AppFailure
      return Left(
        AppFailure(e.toString()),
      );
    }
  }
}
