import 'package:flutter/material.dart';

class TripTypeSelection extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const TripTypeSelection({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: RadioListTile<String>(
            title: const Text('One Way'),
            value: 'Ida',
            groupValue: value,
            onChanged: (newValue) => onChanged(newValue!),
          ),
        ),
        Expanded(
          child: RadioListTile<String>(
            title: const Text('Round Trip'),
            value: 'IdaVolta',
            groupValue: value,
            onChanged: (newValue) => onChanged(newValue!),
          ),
        ),
      ],
    );
  }
}

