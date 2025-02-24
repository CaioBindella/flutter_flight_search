import 'package:flutter/material.dart';
import 'package:flutter_flight_search/screens/results_screen.dart';
import 'package:flutter_flight_search/services/api_service.dart';
import 'package:flutter_flight_search/widgets/airline_selection.dart';
import 'package:flutter_flight_search/widgets/airport_input.dart';
import 'package:flutter_flight_search/widgets/date_input.dart';
import 'package:flutter_flight_search/widgets/passenger_input.dart';
import 'package:flutter_flight_search/widgets/trip_type_selection.dart';
import 'package:intl/intl.dart';

class SearchFormScreen extends StatefulWidget {
  const SearchFormScreen({Key? key}) : super(key: key);

  @override
  _SearchFormScreenState createState() => _SearchFormScreenState();
}

class _SearchFormScreenState extends State<SearchFormScreen> {
  final ApiService _apiService = ApiService();
  List<String> airports = [];

  String origin = '';
  String destination = '';
  DateTime? departureDate;
  DateTime? returnDate;
  List<String> selectedAirlines = [];
  String tripType = 'Ida';
  int adults = 1;
  int children = 0;
  int infants = 0;

  @override
  void initState() {
    super.initState();
    _loadAirports();
  }

  void _loadAirports() async {
    try {
      final airportList = await _apiService.getAirports();
      setState(() {
        airports = airportList;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load airports: $e')),
      );
    }
  }

  void _searchFlights() async {
    if (!_validateForm()) return;

    final dateFormat = DateFormat('dd/MM/yyyy');

    final searchParams = {
      "Origem": origin.toUpperCase(),
      "Destino": destination.toUpperCase(),
      "DataIda": dateFormat.format(departureDate!),
      if (returnDate != null) "DataVolta": dateFormat.format(returnDate!),
      "Companhias":
          selectedAirlines.map((airline) => airline.toUpperCase()).toList(),
      "Tipo": tripType,
      "Adultos": adults,
      "Criancas": children,
      "Bebes": infants,
    };

    print('Enviando busca: $searchParams');

    try {
      final searchId = await _apiService.createSearch(searchParams);
      print('Search created with ID: $searchId');

      // Navega para a ResultsScreen passando o ID da busca
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultsScreen(searchId: searchId),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao buscar voos: $e')),
      );
    }
  }

  bool _validateForm() {
    if (origin.isEmpty || destination.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select origin and destination')),
      );
      return false;
    }
    if (origin.length != 3 || destination.length != 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Origin and destination must be 3-character IATA codes')),
      );
      return false;
    }
    if (departureDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select departure date')),
      );
      return false;
    }
    if (tripType == 'IdaVolta' && returnDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please select return date for round trip')),
      );
      return false;
    }
    if (selectedAirlines.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one airline')),
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flight Search'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AirportInput(
              label: 'Origin',
              onChanged: (value) => setState(() => origin = value),
              airports: airports,
            ),
            const SizedBox(height: 16),
            AirportInput(
              label: 'Destination',
              onChanged: (value) => setState(() => destination = value),
              airports: airports,
            ),
            const SizedBox(height: 16),
            DateInput(
              label: 'Departure Date',
              onChanged: (date) => setState(() => departureDate = date),
            ),
            const SizedBox(height: 16),
            DateInput(
              label: 'Return Date',
              onChanged: (date) => setState(() => returnDate = date),
              enabled: tripType == 'IdaVolta',
            ),
            const SizedBox(height: 16),
            AirlineSelection(
              onChanged: (airlines) =>
                  setState(() => selectedAirlines = airlines),
            ),
            const SizedBox(height: 16),
            TripTypeSelection(
              value: tripType,
              onChanged: (value) => setState(() => tripType = value),
            ),
            const SizedBox(height: 16),
            PassengerInput(
              adults: adults,
              children: children,
              infants: infants,
              onChanged: (a, c, i) => setState(() {
                adults = a;
                children = c;
                infants = i;
              }),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _searchFlights,
              child: const Text('Search Flights'),
            ),
          ],
        ),
      ),
    );
  }
}
