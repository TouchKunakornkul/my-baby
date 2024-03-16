import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_baby/configs/theme.dart';
import 'package:my_baby/providers/child_provider.dart';
import 'package:my_baby/providers/growth_provider.dart';
import 'package:my_baby/widgets/base_date_picker.dart';
import 'package:my_baby/widgets/base_dialog.dart';
import 'package:my_baby/widgets/base_text_input.dart';
import 'package:my_baby/widgets/dimmer_image.dart';
import 'package:provider/provider.dart';

class AddGrowthDialog extends StatefulWidget {
  const AddGrowthDialog({super.key});

  @override
  State<AddGrowthDialog> createState() => _AddGrowthDialogState();
}

class _AddGrowthDialogState extends State<AddGrowthDialog> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  late DateTime _createdAt;

  @override
  void initState() {
    _createdAt = DateTime.now();
    super.initState();
  }

  Future<void> _addGrowth() async {
    final weight = double.tryParse(_weightController.text);
    final height = double.tryParse(_heightController.text);
    if (weight != null) {
      await context
          .read<GrowthProvider>()
          .addGrowth(weight: weight, height: height, createdAt: _createdAt);
      showDialog(
          context: context,
          builder: (ctx) => DimmedImageOverlay(
                imagePath: 'assets/images/growth-greeting.png',
                text: "growth.greeting"
                    .tr(args: [ctx.watch<ChildProvider>().child?.name ?? "-"]),
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      title: 'growth.add_title'.tr(),
      content: Column(children: [
        const SizedBox(
          height: AppTheme.spacing20,
        ),
        BaseDatePicker(
          label: "growth.created_at".tr(),
          value: _createdAt,
          onChange: (date) {
            setState(() {
              _createdAt = date;
            });
          },
        ),
        BaseTextInput(
          label: "growth.weight".tr(),
          type: InputType.number,
          controller: _weightController,
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
          type: InputType.number,
          hintText: "growth.cm".tr(),
          controller: _heightController,
          validator: (value) {
            return null;
          },
        ),
      ]),
      okText: "common.+add".tr(),
      onOk: _addGrowth,
    );
  }
}
