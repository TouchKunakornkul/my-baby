import 'package:flutter/material.dart';
import 'package:my_baby/configs/theme.dart';

class BaseSwitch extends StatelessWidget {
  final Function(bool) onChanged;
  final bool value;

  const BaseSwitch({super.key, required this.onChanged, this.value = false});

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: value,
      onChanged: onChanged,
      trackOutlineWidth: MaterialStateProperty.all(0),
      activeTrackColor: const Color(0xff69E39A),
      activeColor: Colors.white,
      inactiveThumbColor: Colors.white,
      inactiveTrackColor: AppTheme.colorShade.placeholder,
    );
  }
}
