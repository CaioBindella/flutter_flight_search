import 'package:flutter/material.dart';
import 'package:flutter_flight_search/services/api_service.dart';

class ResultsScreen extends StatefulWidget {
  final String searchId;

  const ResultsScreen({Key? key, required this.searchId}) : super(key: key);

  @override
  _ResultsScreenState createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  final ApiService _apiService = ApiService();
  Map<String, dynamic>? results; // Resultados da busca
  bool isLoading = true; // Indicador de carregamento
  String? errorMessage; // Mensagem de erro

  @override
  void initState() {
    super.initState();
    _fetchResults(); // Busca os resultados ao inicializar a tela
  }

  Future<void> _fetchResults() async {
    try {
      // Faz a requisição à API usando o ID da busca
      final response = await _apiService.getSearchResults(widget.searchId);
      setState(() {
        results = response;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load results: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Results'),
      ),
      body: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator()) // Mostra um indicador de carregamento
          : errorMessage != null
              ? Center(
                  child: Text(errorMessage!)) // Mostra uma mensagem de erro
              : results == null || results!['flights'] == null
                  ? const Center(
                      child: Text(
                          'No results found')) // Verifica se os resultados são nulos
                  : ListView.builder(
                      itemCount: results!['flights'].length,
                      itemBuilder: (context, index) {
                        final flight = results!['flights'][index];
                        return Card(
                          child: ListTile(
                            title: Text('${flight['from']} to ${flight['to']}'),
                            subtitle: Text('Date: ${flight['date']}'),
                            trailing: Text('Price: ${flight['price']}'),
                          ),
                        );
                      },
                    ),
    );
  }
}
