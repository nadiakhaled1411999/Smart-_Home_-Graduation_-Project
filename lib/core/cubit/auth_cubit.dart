import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../util/strings.dart';
import 'auth_state.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import your authentication models

class AuthCubit extends Cubit<AuthState> {
  SharedPreferences? prefs;
  static AuthCubit get(context) => BlocProvider.of(context);

  AuthCubit() : super(AuthInitial());

  static const String baseUrl = "http://192.168.43.183";
  static const String port = "5500";

  String get fullUrl => "$baseUrl:$port/api/v1/user";

  Future<void> signIn(String email, String password) async {
    emit(AuthLoading());
    try {
      var dio = Dio();
      log("Request data: email: $email, password: $password");
      Response response = await dio.post(
        "$fullUrl/login",
        data: {"email": email, "password": password},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 && response.data['token'] != null) {
        token = response.data['token'];
        emit(AuthAuthenticated());
      } else {
        emit(AuthError(response.data['msg'] ?? 'Unknown error occurred'));
        log(response.data.toString());
      }
    } on DioError catch (dioError) {
      log("DioError: ${dioError.response?.data.toString() ?? dioError.message}");
      emit(AuthError(dioError.response?.data['msg'] ?? 'An error occurred'));
    } catch (e) {
      log(e.toString());
      emit(AuthError('An unexpected error occurred'));
    }
  }

  Future<void> signUp(String userName, String email, String password) async {
    emit(AuthLoading());
    try {
      var dio = Dio();
      log("Request data: name: $userName, email: $email, password: $password");
      Response response = await dio.post(
        "$fullUrl/register",
        data: {"name": userName, "email": email, "password": password},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        token = response.data['token'];
        log(response.data.toString());
        emit(AuthAuthenticated());
      } else {
        emit(AuthError(response.data['msg'] ?? 'Unknown error occurred'));
        log(response.data.toString());
      }
    } on DioError catch (dioError) {
      log("DioError: ${dioError.response?.data.toString() ?? dioError.message}");
      emit(AuthError(dioError.response?.data['msg'] ?? 'An error occurred'));
    } catch (e) {
      log(e.toString());
      emit(AuthError('An unexpected error occurred'));
    }
  }

  Future<void> forgetPassword(String email) async {
    emit(AuthLoading());
    try {
      var dio = Dio();
      log("Request data: email: $email");
      Response response = await dio.post(
        "$fullUrl/forget-password",
        data: {"email": email},
      );

      if (response.data['success'] == true) {
        emit(AuthAuthenticated());
      } else {
        emit(AuthError(response.data['msg'] ?? 'Unknown error occurred'));
        log(response.data.toString());
      }
    } on DioError catch (dioError) {
      log("DioError: ${dioError.response?.data.toString() ?? dioError.message}");
      emit(AuthError(dioError.response?.data['msg'] ?? 'An error occurred'));
    } catch (e) {
      log(e.toString());
      emit(AuthError('An unexpected error occurred'));
    }
  }

  Future<void> resetPassword(String code, String password) async {
    emit(AuthLoading());
    try {
      var dio = Dio();
      log("Request data: password: $password, code: $code");
      Response response = await dio.post(
        "$fullUrl/reset-password",
        data: {"password": password, "token": code},
      );

      if (response.data['success'] == true) {
        emit(AuthAuthenticated());
      } else {
        emit(AuthError(response.data['msg'] ?? 'Unknown error occurred'));
        log(response.data.toString());
      }
    } on DioError catch (dioError) {
      log("DioError: ${dioError.response?.data.toString() ?? dioError.message}");
      emit(AuthError(dioError.response?.data['msg'] ?? 'An error occurred'));
    } catch (e) {
      log(e.toString());
      emit(AuthError('An unexpected error occurred'));
    }
  }

  Future<void> sendEmailVerification(String email) async {
    try {
      var dio = Dio();
      log("Request data: email: $email");
      Response response = await dio.post(
        "$fullUrl/sendEmail-verify",
        data: {"email": email},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.data['success'] == true) {
        // emit(AuthAuthenticated());
      } else {
        emit(AuthError(response.data['msg'] ?? 'Unknown error occurred'));
        log(response.data.toString());
      }
    } on DioError catch (dioError) {
      log("DioError: ${dioError.response?.data.toString() ?? dioError.message}");
      emit(AuthError(dioError.response?.data['msg'] ?? 'An error occurred'));
    } catch (e) {
      log(e.toString());
      emit(AuthError('An unexpected error occurred'));
    }
  }

  Future<void> verifyEmail(String email, String code) async {
    emit(AuthLoading());
    try {
      var dio = Dio();
      log("Request data: email: $email, code: $code");
      Response response = await dio.post(
        "$fullUrl/verify-email",
        data: {"email": email, "verifyCode": code},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.data['success'] == true) {
        emit(AuthAuthenticated());
      } else {
        emit(AuthError(response.data['msg'] ?? 'Unknown error occurred'));
        log(response.data.toString());
      }
    } on DioError catch (dioError) {
      log("DioError: ${dioError.response?.data.toString() ?? dioError.message}");
      emit(AuthError(dioError.response?.data['msg'] ?? 'An error occurred'));
    } catch (e) {
      log(e.toString());
      emit(AuthError('An unexpected error occurred'));
    }
  }

  Future<void> userProfile() async {
    emit(AuthLoading());
    try {
      var dio = Dio();
      Response response = await dio.get(
        "$fullUrl/profile",
      );

      if (response.data['success'] == true) {
        emit(AuthAuthenticated());
      } else {
        emit(AuthError(response.data['msg'] ?? 'Unknown error occurred'));
        log(response.data.toString());
      }
    } on DioError catch (dioError) {
      log("DioError: ${dioError.response?.data.toString() ?? dioError.message}");
      emit(AuthError(dioError.response?.data['msg'] ?? 'An error occurred'));
    } catch (e) {
      log(e.toString());
      emit(AuthError('An unexpected error occurred'));
    }
  }

  Future<void> userLogout() async {
    emit(AuthLoading());
    try {
      var dio = Dio();
      Response response = await dio.get(
        "$fullUrl/logout",
      );

      if (response.data['success'] == true) {
        token = '';
        emit(LogoutState());
      } else {
        emit(AuthError(response.data['msg'] ?? 'Unknown error occurred'));
        log(response.data.toString());
      }
    } on DioError catch (dioError) {
      log("DioError: ${dioError.response?.data.toString() ?? dioError.message}");
      emit(AuthError(dioError.response?.data['msg'] ?? 'An error occurred'));
    } catch (e) {
      log(e.toString());
      emit(AuthError('An unexpected error occurred'));
    }
  }
}
