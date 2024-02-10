import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_baby/configs/theme.dart';
import 'package:my_baby/models/poo_pee_model.dart';
import 'package:my_baby/providers/poo_pee_provider.dart';
import 'package:my_baby/widgets/base_bottom_sheet.dart';
import 'package:my_baby/widgets/base_date_picker.dart';
import 'package:my_baby/widgets/base_dialog.dart';
import 'package:my_baby/widgets/base_select_input.dart';
import 'package:my_baby/widgets/base_time_picker.dart';
import 'package:provider/provider.dart';

class AddPooPeeDialog extends StatefulWidget {
  const AddPooPeeDialog({super.key});

  @override
  State<AddPooPeeDialog> createState() => _AddPooPeeDialogState();
}

class _AddPooPeeDialogState extends State<AddPooPeeDialog> {
  PooPeeType _type = PooPeeType.poo;
  DateTime _createdAt = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _addPooPee() async {
    await context
        .read<PooPeeProvider>()
        .addPooPee(createdAt: _createdAt, type: _type);
  }

  void _onChangeType(String value) {
    setState(() {
      _type = PooPeeType.values.firstWhere((e) => e.name == value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      title: 'poo_pee.add_title'.tr(),
      content: Column(children: [
        const SizedBox(
          height: AppTheme.spacing20,
        ),
        BaseDatePicker(
          label: "poo_pee.date".tr(),
          value: _createdAt,
          onChange: (date) {
            setState(() {
              _createdAt = date;
            });
          },
        ),
        BaseTimePicker(
          label: "poo_pee.time".tr(),
          initialTime: _createdAt,
          onChange: (time) {
            setState(() {
              _createdAt = time;
            });
          },
        ),
        BaseSelectInput(
          hint: "poo_pee.type_placeholder".tr(),
          items: PooPeeType.values
              .map((e) => SelectItem(label: e.label, value: e.name))
              .toList(),
          initialValue: _type.name,
          onChanged: _onChangeType,
          label: "poo_pee.type_label".tr(),
        ),
      ]),
      okText: "common.+add".tr(),
      onOk: _addPooPee,
    );
  }
}
