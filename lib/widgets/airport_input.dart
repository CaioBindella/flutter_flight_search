import 'package:flutter/material.dart';

class AirportInput extends StatelessWidget {
  final String label;
  final ValueChanged<String> onChanged;

  const AirportInput({
    Key? key,
    required this.label,
    required this.onChanged,
    required List<String> airports,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      onChanged: onChanged,
    );
  }
}
