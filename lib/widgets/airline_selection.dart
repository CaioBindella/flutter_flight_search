import 'package:flutter/material.dart';

class AirlineSelection extends StatefulWidget {
  final ValueChanged<List<String>> onChanged;

  const AirlineSelection({Key? key, required this.onChanged}) : super(key: key);

  @override
  _AirlineSelectionState createState() => _AirlineSelectionState();
}

class _AirlineSelectionState extends State<AirlineSelection> {
  final List<String> airlines = [
    'AMERICAN AIRLINES',
    'GOL',
    'IBERIA',
    'INTERLINE',
    'LATAM',
    'AZUL',
    'TAP',
  ];

  List<String> selectedAirlines = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Select Airlines (1-7):'),
        Wrap(
          spacing: 8,
          children: airlines.map((airline) {
            return FilterChip(
              label: Text(airline),
              selected: selectedAirlines.contains(airline),
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    if (selectedAirlines.length < 7) {
                      selectedAirlines.add(airline);
                    }
                  } else {
                    selectedAirlines.remove(airline);
                  }
                });
                widget.onChanged(selectedAirlines);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
