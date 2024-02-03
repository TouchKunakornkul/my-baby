import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_baby/widgets/base_text_input.dart';

class BaseTimePicker extends StatefulWidget {
  final DateTime? initialTime;
  final Function(DateTime)? onChange;
  final String? label;

  const BaseTimePicker({
    Key? key,
    this.initialTime,
    this.onChange,
    this.label,
  }) : super(key: key);

  @override
  _BaseTimePickerState createState() => _BaseTimePickerState();
}

class _BaseTimePickerState extends State<BaseTimePicker> {
  late DateTime _selectedTime;

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _selectedTime = widget.initialTime ?? DateTime.now();
    _controller.text = DateFormat("HH:mm").format(_selectedTime);
    super.initState();
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime != null
          ? TimeOfDay.fromDateTime(_selectedTime)
          : TimeOfDay.now(),
    );
    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = DateTime(
          _selectedTime.year,
          _selectedTime.month,
          _selectedTime.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        _controller.text = DateFormat("HH:mm").format(_selectedTime);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _selectTime(context),
      child: AbsorbPointer(
        absorbing: true,
        child: BaseTextInput(
          label: widget.label,
          controller: _controller,
        ),
      ),
    );
  }
}
