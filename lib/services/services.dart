import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:desafio_flutter/data_classes/data.dart';

class Services {
  Future<Data> fetchData() async {
    final response = await http
      .get(Uri.parse('https://raw.githubusercontent.com/App2Sales/mobile-challenge/master/content.json'));
    if (response.statusCode == 200) {
      Map jsonResponse = json.decode(response.body);
      return Data.fromJson(jsonResponse);
    } else {
      throw Exception('Falha ao carregar dados');
    }
  }
}