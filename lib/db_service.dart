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

  // get reminders using a bearer access token from the server
  Future<List<Map<String, dynamic>>> fetchReminders(String accessToken) async {
    try {
      final response = await dio.get(
        '$baseUrl/reminders/',
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      // Check if the response is successful
      if (response.statusCode == 200) {
        // Add a success indicator to the response data
        final List<dynamic> responseData = List<dynamic>.from(response.data);
        final List<Map<String, dynamic>> reminders = [];
        for (var reminder in responseData) {
          reminders.add(Map<String, dynamic>.from(reminder));
        }
        return reminders;
      } else if (response.statusCode == 401) {
        return [];
      } else {
        // Return the response data with success set to false
        return [];
      }
    } catch (e) {
      return [];
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

  // get emotional chart records using a bearer access token from the server
  Future<Map<String, dynamic>> fetchEmotionalChartRecords(
      String accessToken) async {
    try {
      final response = await dio.get(
        '$baseUrl/charts/emotions/',
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

  // get specific careChart data using id
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

  // get specific vitalChart data using id
  Future<Map<String, dynamic>> fetchVitalChartData(
      int id, String accessToken) async {
    try {
      final response = await dio.get(
        '$baseUrl/charts/vitals/$id/',
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

  // get specific emotionalChart data using id
  Future<Map<String, dynamic>> fetchEmotionalChartData(
      int id, String accessToken) async {
    try {
      final response = await dio.get(
        '$baseUrl/charts/emotions/$id/',
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

  Future<Map<String, dynamic>> fetchDocuments(
      String accessToken, int patientId) async {
    try {
      final response = await dio.get(
        '$baseUrl/patients/$patientId/documents/',
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
      } else if (response.statusCode == 400) {
        return {'success': false, 'error': 'Bad Request'};
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

  // fetch a single document using id it returns a body of a pdf file
  // localhost:8000/api/patients/9/documents/1
  Future<Map<String, dynamic>> fetchDocument(
      String accessToken, int patientId, int documentId) async {
    try {
      final response = await dio.get(
        '$baseUrl/patients/$patientId/documents/$documentId/',
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
      } else if (response.statusCode == 400) {
        return {'success': false, 'error': 'Bad Request'};
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
