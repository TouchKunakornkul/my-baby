import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_baby/widgets/base_text_input.dart';

class BaseDatePicker extends StatefulWidget {
  final DateTime value;
  final Function(DateTime) onChange;
  final String? label;
  const BaseDatePicker({
    super.key,
    required this.value,
    required this.onChange,
    this.label,
  });

  @override
  State<BaseDatePicker> createState() => _BaseDatePickerState();
}

class _BaseDatePickerState extends State<BaseDatePicker> {
  final TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    _controller.text = DateFormat('dd MMM yyyy').format(widget.value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(0),
            lastDate: DateTime.now());

        if (pickedDate != null) {
          String formattedDate = DateFormat('dd MMM yyyy').format(pickedDate);
          widget.onChange(pickedDate);
          setState(() {
            _controller.text =
                formattedDate; //set output date to TextField value.
          });
        }
      },
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
