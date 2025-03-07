import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as https;

class HttpHandler {
  static const String _baseUrl = "https://finnhub.io/api/v1";
  static const String _apiKey = "crals9pr01qhk4bqotb0crals9pr01qhk4bqotbg";

  static Future<List<dynamic>> getMarketNews(
      {String category = 'general'}) async {
    final url = Uri.parse('$_baseUrl/news?category=$category&token=$_apiKey');

    try {
      final response = await https.get(url);

      return _processNewsResponse(response);
    } catch (e) {
      Get.showSnackbar(const GetSnackBar(
          titleText: Text(
            "Connection Error...",
            style: TextStyle(fontWeight: FontWeight.w700,color: Colors.black),
          ),
          messageText: Text(
              "Failed to fetch news. Please check your connection and try again.",
              style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black)),
          snackPosition: SnackPosition.TOP,
          duration: Duration(seconds: 3),
          backgroundColor: Colors.white));
      rethrow;
    }
  }

  static List<dynamic> _processNewsResponse(https.Response response) {
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to load news data: ${response.statusCode}");
    }
  }
}
