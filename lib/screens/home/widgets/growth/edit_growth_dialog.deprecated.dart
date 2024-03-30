import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_baby/configs/theme.dart';
import 'package:my_baby/providers/growth_provider.dart';
import 'package:my_baby/utils/double_utils.dart';
import 'package:my_baby/widgets/base_bottom_sheet.dart';
import 'package:my_baby/widgets/base_dialog.dart';
import 'package:my_baby/widgets/base_select_input.dart';
import 'package:my_baby/widgets/base_text_input.dart';
import 'package:provider/provider.dart';

class EditGrowthDialog extends StatefulWidget {
  const EditGrowthDialog({
    super.key,
  });

  @override
  State<EditGrowthDialog> createState() => _EditGrowthDialogState();
}

class _EditGrowthDialogState extends State<EditGrowthDialog> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  late String _selectedItem;

  @override
  void initState() {
    final growths = context.read<GrowthProvider>().growths;
    _selectedItem = growths[0].id.toString();

    _weightController.text = formatDouble(growths[0].weight);
    _heightController.text =
        growths[0].height != null ? formatDouble(growths[0].height!) : "";
    super.initState();
  }

  Future<void> _editGrowth() async {
    final weight = double.tryParse(_weightController.text);
    final height = double.tryParse(_heightController.text);
    if (weight != null) {
      final growths = context.read<GrowthProvider>().growths;
      final updatedGrowth =
          growths.firstWhere((g) => g.id.toString() == _selectedItem);
      await context
          .read<GrowthProvider>()
          .edit(updatedGrowth, weight, height, updatedGrowth.createdAt);
    }
  }

  _onChangeDate(String value) {
    final growths = context.read<GrowthProvider>().growths;
    final selectedGrowth =
        growths.firstWhere((g) => g.id.toString() == _selectedItem);
    _weightController.text = formatDouble(selectedGrowth.weight);
    _heightController.text = selectedGrowth.height != null
        ? formatDouble(selectedGrowth.height!)
        : "";
    setState(() {
      _selectedItem = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final growthList = context
        .watch<GrowthProvider>()
        .growths
        .map((e) => SelectItem(
            label: DateFormat('d MMM yyyy HH:mm').format(e.createdAt),
            value: e.id.toString()))
        .toList();
    return BaseDialog(
      title: 'growth.edit_title'.tr(),
      content: Column(children: [
        const SizedBox(
          height: AppTheme.spacing20,
        ),
        BaseSelectInput(
          hint: "growth.created_at".tr(),
          items: growthList,
          initialValue: _selectedItem,
          onChanged: _onChangeDate,
          label: "growth.created_at".tr(),
        ),
        const SizedBox(
          height: AppTheme.spacing36,
        ),
        BaseTextInput(
          label: "growth.weight".tr(),
          controller: _weightController,
          type: InputType.number,
          hintText: "growth.kg".tr(),
          validator: (value) {
            if (value == null || value == "") {
              return "error.form_required".tr();
            }
            return null;
          },
        ),
        BaseTextInput(
          label: "growth.height".tr(),
          hintText: "growth.cm".tr(),
          controller: _heightController,
          type: InputType.number,
          validator: (value) {
            return null;
          },
        ),
      ]),
      okText: "common.save".tr(),
      onOk: _editGrowth,
    );
  }
}
