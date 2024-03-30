import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_baby/configs/theme.dart';
import 'package:my_baby/providers/feeding_provider.dart';
import 'package:my_baby/widgets/base_bottom_sheet.dart';
import 'package:my_baby/widgets/base_dialog.dart';
import 'package:my_baby/widgets/base_select_input.dart';
import 'package:my_baby/widgets/base_time_picker.dart';
import 'package:provider/provider.dart';

final ROUTINES = [1, 2, 3, 4, 6];

class FeedingRoutineDialog extends StatefulWidget {
  const FeedingRoutineDialog({Key? key}) : super(key: key);

  @override
  State<FeedingRoutineDialog> createState() => _FeedingRoutineDialogState();
}

class _FeedingRoutineDialogState extends State<FeedingRoutineDialog> {
  late DateTime _startTime;
  int _routine = 2;

  DateTime toQuarterHour(DateTime dateTime) {
    final int minutes = dateTime.minute;
    final int remainder = minutes % 5;

    return dateTime.subtract(Duration(minutes: remainder));
  }

  @override
  void initState() {
    _startTime = context.read<FeedingProvider>().startTime ??
        toQuarterHour(DateTime.now());
    super.initState();
  }

  void _onChangeRoutine(String value) {
    setState(() {
      _routine = int.parse(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      title: "feeding.routine.title".tr(),
      okText: "common.save".tr(),
      onOk: () {
        context.read<FeedingProvider>().setNotification(_startTime, _routine);
      },
      content: Column(
        children: [
          const SizedBox(
            height: AppTheme.spacing20,
          ),
          BaseTimePicker(
            label: "feeding.routine.start_at".tr(),
            initialTime: _startTime,
            onChange: (time) {
              setState(() {
                _startTime = time;
              });
            },
          ),
          BaseSelectInput(
            hint: "feeding.routine.routine".tr(),
            items: ROUTINES
                .map((e) => SelectItem(
                    label:
                        "feeding.routine.every_hours".tr(args: [e.toString()]),
                    value: e.toString()))
                .toList(),
            initialValue: _routine.toString(),
            onChanged: _onChangeRoutine,
            label: "feeding.routine.routine".tr(),
          ),
        ],
      ),
    );
  }
}
