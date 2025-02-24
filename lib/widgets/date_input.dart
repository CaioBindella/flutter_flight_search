import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateInput extends StatefulWidget {
  final String label;
  final Function(DateTime) onChanged;
  final bool enabled;

  const DateInput({
    Key? key,
    required this.label,
    required this.onChanged,
    this.enabled = true,
  }) : super(key: key);

  @override
  DateInputState createState() => DateInputState();
}

class DateInputState extends State<DateInput> {
  final TextEditingController _controller = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        _controller.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      });
      widget.onChanged(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        labelText: widget.label,
        suffixIcon: const Icon(Icons.calendar_today),
      ),
      readOnly: true,
      onTap: widget.enabled ? () => _selectDate(context) : null,
    );
  }
}
