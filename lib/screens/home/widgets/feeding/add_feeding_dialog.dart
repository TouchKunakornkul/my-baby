import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_baby/configs/theme.dart';
import 'package:my_baby/providers/feeding_provider.dart';
import 'package:my_baby/widgets/base_bottom_sheet.dart';
import 'package:my_baby/widgets/base_date_picker.dart';
import 'package:my_baby/widgets/base_dialog.dart';
import 'package:my_baby/widgets/base_select_input.dart';
import 'package:my_baby/widgets/base_text_input.dart';
import 'package:my_baby/widgets/base_time_picker.dart';
import 'package:provider/provider.dart';

class AddFeedingDialog extends StatefulWidget {
  const AddFeedingDialog({super.key});

  @override
  State<AddFeedingDialog> createState() => _AddFeedingDialogState();
}

class _AddFeedingDialogState extends State<AddFeedingDialog> {
  final TextEditingController _amountController = TextEditingController();
  FeedingType _type = FeedingType.bottle;
  DateTime _feedTime = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _addFeeding() async {
    final amount = double.tryParse(_amountController.text);
    if (amount != null) {
      await context
          .read<FeedingProvider>()
          .addFeeding(feedTime: _feedTime, amount: amount, type: _type);
    }
  }

  void _onChangeType(String value) {
    setState(() {
      _type = FeedingType.values.firstWhere((e) => e.name == value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      title: 'feeding.add_title'.tr(),
      content: Column(children: [
        const SizedBox(
          height: AppTheme.spacing20,
        ),
        BaseDatePicker(
          label: "feeding.created_at".tr(),
          value: _feedTime,
          onChange: (date) {
            setState(() {
              _feedTime = date;
            });
          },
        ),
        BaseTimePicker(
          label: "feeding.time".tr(),
          initialTime: _feedTime,
          onChange: (time) {
            setState(() {
              _feedTime = time;
            });
          },
        ),
        BaseTextInput(
          label: "feeding.amount".tr(),
          type: InputType.number,
          controller: _amountController,
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
        const SizedBox(
          height: AppTheme.spacing24,
        ),
      ]),
      cancelText: "common.add".tr(),
      onClose: _addFeeding,
    );
  }
}
