import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:srikandi_sehat_app/models/symptom_detail_model.dart';

class SymptomDetailProvider with ChangeNotifier {
  SymptomDetail? _detail;
  bool _isLoading = false;

  SymptomDetail? get detail => _detail;
  bool get isLoading => _isLoading;

  Future<void> fetchDetail(int id) async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      final baseUrl = dotenv.env['API_URL'];
      final url = '$baseUrl/cycles/symptoms/$id';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      _isLoading = false;

      final data = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        _detail = SymptomDetail.fromJson(data['data']);
      }
      print('Response: ${data}');
    } catch (e) {
      debugPrint('Error fetchDetail: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
}
