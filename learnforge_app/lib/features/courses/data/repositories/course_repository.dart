import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:learnforge_app/core/constants/api_constants.dart';
import 'package:learnforge_app/features/courses/models/course_model.dart';
// import 'package:learnforge_app/features/courses/data/models/course_model.dart'; // Deleted

class CourseRepository {
  Future<List<Course>> getAllCourses() async {
    // try {
      final uri = Uri.parse('${ApiConstants.baseUrl}/courses');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Course.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load courses: ${response.statusCode}');
      }
    // } catch (e) {
    //   throw Exception('Network error: $e');
    // }
  }

  Future<Course> getCourseById(String id) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}/courses/$id');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return Course.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load course: ${response.statusCode}');
    }
  }

  Future<List<Course>> searchCourses(String keyword) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}/courses/search?keyword=$keyword');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Course.fromJson(json)).toList();
    } else {
      throw Exception('Failed to search courses');
    }
  }
}
