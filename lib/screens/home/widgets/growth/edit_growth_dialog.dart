import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_baby/configs/database.dart';
import 'package:my_baby/configs/theme.dart';
import 'package:my_baby/providers/growth_provider.dart';
import 'package:my_baby/utils/double_utils.dart';
import 'package:my_baby/widgets/base_dialog.dart';
import 'package:my_baby/widgets/base_text_input.dart';
import 'package:provider/provider.dart';

class EditGrowthDialog extends StatefulWidget {
  final Growth growth;
  const EditGrowthDialog({
    super.key,
    required this.growth,
  });

  @override
  State<EditGrowthDialog> createState() => _EditGrowthDialogState();
}

class _EditGrowthDialogState extends State<EditGrowthDialog> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    final growth = widget.growth;
    _weightController.text = formatDouble(growth.weight);
    _heightController.text =
        growth.height != null ? formatDouble(growth.height!) : "";
    _dateController.text =
        DateFormat('d MMM yyyy HH:mm').format(growth.createdAt);
    super.initState();
  }

  Future<void> _editGrowth() async {
    final weight = double.tryParse(_weightController.text);
    final height = double.tryParse(_heightController.text);
    if (weight != null) {
      await context.read<GrowthProvider>().edit(widget.growth, weight, height);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      title: 'growth.edit_title'.tr(),
      content: Column(children: [
        const SizedBox(
          height: AppTheme.spacing20,
        ),
        BaseTextInput(
          enabled: false,
          controller: _dateController,
          label: "growth.created_at".tr(),
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
