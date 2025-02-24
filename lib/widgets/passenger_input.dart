import 'package:flutter/material.dart';

class PassengerInput extends StatelessWidget {
  final int adults;
  final int children;
  final int infants;
  final Function(int, int, int) onChanged;

  const PassengerInput({
    Key? key,
    required this.adults,
    required this.children,
    required this.infants,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Passengers:'),
        Row(
          children: [
            Expanded(
              child: _PassengerTypeInput(
                label: 'Adults',
                value: adults,
                onChanged: (value) => onChanged(value, children, infants),
                min: 1,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _PassengerTypeInput(
                label: 'Children',
                value: children,
                onChanged: (value) => onChanged(adults, value, infants),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _PassengerTypeInput(
                label: 'Infants',
                value: infants,
                onChanged: (value) => onChanged(adults, children, value),
                max: adults,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PassengerTypeInput extends StatelessWidget {
  final String label;
  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int? max;

  const _PassengerTypeInput({
    Key? key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: value > min ? () => onChanged(value - 1) : null,
            ),
            Text('$value'),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: max == null || value < max!
                  ? () => onChanged(value + 1)
                  : null,
            ),
          ],
        ),
      ],
    );
  }
}

