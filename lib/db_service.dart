import 'package:dio/dio.dart';

class DbService {
  final baseUrl = 'http://localhost:8000/api';
  final Dio dio = Dio();

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await dio.post(
        '$baseUrl/users/login/',
        data: {
          'username': username,
          'password': password,
        },
      );

      // Check if the response is successful
      if (response.statusCode == 200) {
        // Add a success indicator to the response data
        final Map<String, dynamic> responseData =
            Map<String, dynamic>.from(response.data);
        responseData['success'] = true;
        return responseData;
      } else {
        // Return the response data with success set to false
        final Map<String, dynamic> responseData =
            Map<String, dynamic>.from(response.data);
        responseData['success'] = false;
        return responseData;
      }
    } catch (e) {
      // Return an error map with success set to false
      print(e.toString());
      return {'success': false, 'error': e.toString()};
    }
  }

  // get patients using a bearer access token from the server
  Future<Map<String, dynamic>> fetchPatients(String accessToken) async {
    try {
      final response = await dio.get(
        '$baseUrl/patients/',
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      // Check if the response is successful
      if (response.statusCode == 200) {
        // Add a success indicator to the response data
        final Map<String, dynamic> responseData =
            Map<String, dynamic>.from(response.data);
        responseData['success'] = true;
        return responseData;
      } else if (response.statusCode == 401) {
        return {'success': false, 'error': 'Unauthorized'};
      } else {
        // Return the response data with success set to false
        final Map<String, dynamic> responseData =
            Map<String, dynamic>.from(response.data);
        responseData['success'] = false;
        return responseData;
      }
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  // get refreshed access token using refresh token
  Future<Map<String, dynamic>> refreshAccessToken(String refreshToken) async {
    try {
      final response = await dio.post(
        '$baseUrl/api/users/refresh-token/',
        data: {
          'refresh': refreshToken,
        },
      );

      // Check if the response is successful
      if (response.statusCode == 200) {
        // Add a success indicator to the response data
        final Map<String, dynamic> responseData =
            Map<String, dynamic>.from(response.data);
        responseData['success'] = true;
        return responseData;
      } else {
        // Return the response data with success set to false
        final Map<String, dynamic> responseData =
            Map<String, dynamic>.from(response.data);
        responseData['success'] = false;
        return responseData;
      }
    } catch (e) {
      // Return an error map with success set to false
      return {'success': false, 'error': e.toString()};
    }
  }

  // fetch data of a specific patient using an Map<String, dynamic>
  Future<Map<String, dynamic>> fetchPatientData(
      int patientId, String accessToken) async {
    try {
      final response = await dio.get(
        '$baseUrl/patients/$patientId/',
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      // Check if the response is successful
      if (response.statusCode == 200) {
        // Add a success indicator to the response data
        final Map<String, dynamic> responseData =
            Map<String, dynamic>.from(response.data);
        responseData['success'] = true;
        return responseData;
      } else if (response.statusCode == 401) {
        return {'success': false, 'error': 'Unauthorized'};
      } else {
        // Return the response data with success set to false
        final Map<String, dynamic> responseData =
            Map<String, dynamic>.from(response.data);
        responseData['success'] = false;
        return responseData;
      }
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  // get care chart records using a bearer access token from the server
  Future<Map<String, dynamic>> fetchCareChartRecords(String accessToken) async {
    try {
      final response = await dio.get(
        '$baseUrl/charts/care/',
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      // Check if the response is successful
      if (response.statusCode == 200) {
        // Add a success indicator to the response data
        final Map<String, dynamic> responseData =
            Map<String, dynamic>.from(response.data);
        responseData['success'] = true;
        return responseData;
      } else if (response.statusCode == 401) {
        return {'success': false, 'error': 'Unauthorized'};
      } else {
        // Return the response data with success set to false
        final Map<String, dynamic> responseData =
            Map<String, dynamic>.from(response.data);
        responseData['success'] = false;
        return responseData;
      }
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  // get vital chart records using a bearer access token from the server
  Future<Map<String, dynamic>> fetchVitalChartRecords(
      String accessToken) async {
    try {
      final response = await dio.get(
        '$baseUrl/charts/vitals/',
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      // Check if the response is successful
      if (response.statusCode == 200) {
        // Add a success indicator to the response data
        final Map<String, dynamic> responseData =
            Map<String, dynamic>.from(response.data);
        responseData['success'] = true;
        return responseData;
      } else if (response.statusCode == 401) {
        return {'success': false, 'error': 'Unauthorized'};
      } else {
        // Return the response data with success set to false
        final Map<String, dynamic> responseData =
            Map<String, dynamic>.from(response.data);
        responseData['success'] = false;
        return responseData;
      }
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  // get specific careChare data using id
  Future<Map<String, dynamic>> fetchCareChartData(
      int id, String accessToken) async {
    try {
      final response = await dio.get(
        '$baseUrl/charts/care/$id/',
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      // Check if the response is successful
      if (response.statusCode == 200) {
        // Add a success indicator to the response data
        final Map<String, dynamic> responseData =
            Map<String, dynamic>.from(response.data);
        responseData['success'] = true;
        return responseData;
      } else if (response.statusCode == 401) {
        return {'success': false, 'error': 'Unauthorized'};
      } else {
        // Return the response data with success set to false
        final Map<String, dynamic> responseData =
            Map<String, dynamic>.from(response.data);
        responseData['success'] = false;
        return responseData;
      }
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }
}
