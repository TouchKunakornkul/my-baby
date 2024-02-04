import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_baby/configs/theme.dart';
import 'package:my_baby/providers/feeding_provider.dart';
import 'package:my_baby/utils/double_utils.dart';
import 'package:my_baby/widgets/base_bottom_sheet.dart';
import 'package:my_baby/widgets/base_dialog.dart';
import 'package:my_baby/widgets/base_select_input.dart';
import 'package:my_baby/widgets/base_text_input.dart';
import 'package:provider/provider.dart';

class EditFeedingDialog extends StatefulWidget {
  const EditFeedingDialog({
    super.key,
  });

  @override
  State<EditFeedingDialog> createState() => _EditFeedingDialogState();
}

class _EditFeedingDialogState extends State<EditFeedingDialog> {
  final TextEditingController _amountController = TextEditingController();
  late FeedingType _type;
  late String _selectedItem;

  @override
  void initState() {
    final feedings = context.read<FeedingProvider>().feedings;
    _selectedItem = feedings[0].id.toString();

    _amountController.text = formatDouble(feedings[0].amount);
    _type = stringToFeedingType(feedings[0].type);
    super.initState();
  }

  Future<void> _editFeeding() async {
    final amount = double.tryParse(_amountController.text);
    if (amount != null) {
      final feedings = context.read<FeedingProvider>().feedings;
      final updatedFeeding =
          feedings.firstWhere((f) => f.id.toString() == _selectedItem);
      await context.read<FeedingProvider>().updateFeeding(
          updatedFeeding.copyWith(amount: amount, type: _type.name));
    }
  }

  _onChangeDate(String value) {
    final feedings = context.read<FeedingProvider>().feedings;
    final selectedFeeding =
        feedings.firstWhere((f) => f.id.toString() == _selectedItem);
    setState(() {
      _amountController.text = formatDouble(selectedFeeding.amount);
      _type = stringToFeedingType(selectedFeeding.type);
      _selectedItem = value;
    });
  }

  void _onChangeType(String value) {
    setState(() {
      _type = FeedingType.values.firstWhere((e) => e.name == value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final feedTimeList = context
        .watch<FeedingProvider>()
        .feedings
        .map((e) => SelectItem(
            label: DateFormat('d MMM yyyy HH:mm').format(e.feedTime),
            value: e.id.toString()))
        .toList();
    return BaseDialog(
      title: 'feeding.edit_title'.tr(),
      content: Column(children: [
        const SizedBox(
          height: AppTheme.spacing20,
        ),
        BaseSelectInput(
          hint: "feeding.feed_time".tr(),
          items: feedTimeList,
          initialValue: _selectedItem,
          onChanged: _onChangeDate,
          label: "feeding.feed_time".tr(),
        ),
        const SizedBox(
          height: AppTheme.spacing36,
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
        const SizedBox(
          height: AppTheme.spacing24,
        ),
      ]),
      cancelText: "common.save".tr(),
      onClose: _editFeeding,
    );
  }
}
