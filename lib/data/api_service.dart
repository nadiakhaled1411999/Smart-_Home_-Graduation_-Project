import 'dart:developer';

import 'package:dio/dio.dart';

import '../models/projects_model.dart';

class ApiService {
  final Dio _dio = Dio();

  Future<Projects> fetchProjects() async {
    final response = await _dio
        .get("https://graduation-api-zaj9.onrender.com/api/v1/project/all/");
    if (response.data['success'] == true) {
      log(response.data['msg']);
      return Projects.fromJson(response.data);
    } else {
      log("XXXXXXXXXXXX");
      throw Exception('Failed to load projects');
    }
  }

  Future<void> connectData(String projectName, String user) async {
    final response = await _dio.post(
      'https://graduation-api-zaj9.onrender.com/api/v1/connect-data',
      data: {
        'projectName': projectName,
        'user': user,
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to connect data');
    }
  }
}
