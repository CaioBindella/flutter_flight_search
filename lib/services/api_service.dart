import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'https://buscamilhas.mock.gralmeidan.dev';

  Future<String> createSearch(Map<String, dynamic> params) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/busca/criar'),
        body: jsonEncode(params),
        headers: {'Content-Type': 'application/json'},
      );

      print('Response body: ${response.body}'); // Log da resposta

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);

        // Verifica se o campo 'Busca' está presente na resposta
        if (responseData.containsKey('Busca')) {
          return responseData['Busca']; // Retorna o ID da busca
        } else {
          throw Exception('ID not found in response: ${response.body}');
        }
      } else {
        throw Exception('Failed to create search: ${response.body}');
      }
    } catch (e) {
      print('Erro no createSearch: $e'); // Log do erro
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getSearchResults(String searchId) async {
    final response = await http.get(Uri.parse('$baseUrl/busca/$searchId'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to get search results');
    }
  }

  Future<List<String>> getAirports() async {
    final response = await http.get(Uri.parse('$baseUrl/aeroportos'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.cast<String>();
    } else {
      throw Exception('Failed to get airports');
    }
  }
}
