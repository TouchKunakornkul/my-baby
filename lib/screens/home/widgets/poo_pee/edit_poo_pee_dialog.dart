import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_baby/configs/database.dart';
import 'package:my_baby/configs/theme.dart';
import 'package:my_baby/models/poo_pee_model.dart';
import 'package:my_baby/providers/poo_pee_provider.dart';
import 'package:my_baby/widgets/base_bottom_sheet.dart';
import 'package:my_baby/widgets/base_dialog.dart';
import 'package:my_baby/widgets/base_select_input.dart';
import 'package:my_baby/widgets/base_text_input.dart';
import 'package:provider/provider.dart';

class EditPooPeeDialog extends StatefulWidget {
  final PooPee pooPee;
  const EditPooPeeDialog({
    super.key,
    required this.pooPee,
  });

  @override
  State<EditPooPeeDialog> createState() => _EditPooPeeDialogState();
}

class _EditPooPeeDialogState extends State<EditPooPeeDialog> {
  final TextEditingController _dateController = TextEditingController();
  late PooPeeType _type;

  @override
  void initState() {
    final pooPee = widget.pooPee;
    _dateController.text =
        DateFormat('d MMM yyyy HH:mm').format(pooPee.createdAt);
    _type = stringToPooPeeType(pooPee.type);
    super.initState();
  }

  Future<void> _editPooPee() async {
    await context
        .read<PooPeeProvider>()
        .updatePooPee(widget.pooPee.copyWith(type: _type.name));
  }

  void _onChangeType(String value) {
    setState(() {
      _type = PooPeeType.values.firstWhere((e) => e.name == value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final feedTimeList = context
        .watch<PooPeeProvider>()
        .pooPees
        .map((e) => SelectItem(
            label: DateFormat('d MMM yyyy HH:mm').format(e.createdAt),
            value: e.id.toString()))
        .toList();
    return BaseDialog(
      title: 'poo_pee.edit_title'.tr(),
      content: Column(children: [
        const SizedBox(
          height: AppTheme.spacing20,
        ),
        BaseTextInput(
          enabled: false,
          controller: _dateController,
          label: "poo_pee.created_at".tr(),
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
      okText: "common.save".tr(),
      onOk: _editPooPee,
    );
  }
}
