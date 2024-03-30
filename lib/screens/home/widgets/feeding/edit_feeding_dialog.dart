import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_baby/configs/database.dart';
import 'package:my_baby/configs/theme.dart';
import 'package:my_baby/providers/feeding_provider.dart';
import 'package:my_baby/utils/double_utils.dart';
import 'package:my_baby/widgets/base_bottom_sheet.dart';
import 'package:my_baby/widgets/base_date_picker.dart';
import 'package:my_baby/widgets/base_dialog.dart';
import 'package:my_baby/widgets/base_select_input.dart';
import 'package:my_baby/widgets/base_text_input.dart';
import 'package:my_baby/widgets/base_time_picker.dart';
import 'package:provider/provider.dart';

class EditFeedingDialog extends StatefulWidget {
  final Feeding feeding;
  const EditFeedingDialog({
    super.key,
    required this.feeding,
  });

  @override
  State<EditFeedingDialog> createState() => _EditFeedingDialogState();
}

class _EditFeedingDialogState extends State<EditFeedingDialog> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  late FeedingType _type;
  DateTime _feedTime = DateTime.now();

  @override
  void initState() {
    final feeding = widget.feeding;
    _dateController.text =
        DateFormat('d MMM yyyy HH:mm').format(feeding.feedTime);
    _amountController.text = formatDouble(feeding.amount);
    _type = stringToFeedingType(feeding.type);
    _feedTime = feeding.feedTime;
    super.initState();
  }

  Future<void> _editFeeding() async {
    final amount = double.tryParse(_amountController.text);
    // if (amount != null) {
    await context.read<FeedingProvider>().updateFeeding(widget.feeding
        .copyWith(amount: amount ?? 0, type: _type.name, feedTime: _feedTime));
    // }
  }

  void _onChangeType(String value) {
    setState(() {
      _type = FeedingType.values.firstWhere((e) => e.name == value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      title: 'feeding.edit_title'.tr(),
      content: Column(children: [
        const SizedBox(
          height: AppTheme.spacing20,
        ),
        BaseDatePicker(
          label: "feeding.feeding_date".tr(),
          value: _feedTime,
          onChange: (date) {
            setState(() {
              _feedTime = date;
            });
          },
        ),
        BaseTimePicker(
          label: "feeding.feeding_time".tr(),
          initialTime: _feedTime,
          onChange: (time) {
            setState(() {
              _feedTime = time;
            });
          },
        ),
        BaseTextInput(
          label: "feeding.amount".tr(),
          controller: _amountController,
          type: InputType.number,
          hintText: "feeding.ounce".tr(),
          validator: (value) {
            if (value == null || value == "") {
              return "error.form_required".tr();
            }
            return null;
          },
        ),
        BaseSelectInput(
          hint: "feeding.type_placeholder".tr(),
          items: FeedingType.values
              .map((e) => SelectItem(label: e.label, value: e.name))
              .toList(),
          initialValue: _type.name,
          onChanged: _onChangeType,
          label: "feeding.type_label".tr(),
        ),
      ]),
      okText: "common.save".tr(),
      onOk: _editFeeding,
    );
  }
}
