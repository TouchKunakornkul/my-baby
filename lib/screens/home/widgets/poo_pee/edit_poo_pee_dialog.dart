import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_baby/configs/theme.dart';
import 'package:my_baby/models/poo_pee_model.dart';
import 'package:my_baby/providers/poo_pee_provider.dart';
import 'package:my_baby/widgets/base_bottom_sheet.dart';
import 'package:my_baby/widgets/base_dialog.dart';
import 'package:my_baby/widgets/base_select_input.dart';
import 'package:provider/provider.dart';

class EditPooPeeDialog extends StatefulWidget {
  const EditPooPeeDialog({
    super.key,
  });

  @override
  State<EditPooPeeDialog> createState() => _EditPooPeeDialogState();
}

class _EditPooPeeDialogState extends State<EditPooPeeDialog> {
  late PooPeeType _type;
  late String _selectedItem;

  @override
  void initState() {
    final pooPees = context.read<PooPeeProvider>().pooPees;
    _selectedItem = pooPees[0].id.toString();
    _type = stringToPooPeeType(pooPees[0].type);
    super.initState();
  }

  Future<void> _editPooPee() async {
    final pooPees = context.read<PooPeeProvider>().pooPees;
    final updatedPooPee =
        pooPees.firstWhere((f) => f.id.toString() == _selectedItem);
    await context
        .read<PooPeeProvider>()
        .updatePooPee(updatedPooPee.copyWith(type: _type.name));
  }

  _onChangeDate(String value) {
    final pooPees = context.read<PooPeeProvider>().pooPees;
    final selectedPooPee =
        pooPees.firstWhere((f) => f.id.toString() == _selectedItem);
    setState(() {
      _type = stringToPooPeeType(selectedPooPee.type);
      _selectedItem = value;
    });
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
        BaseSelectInput(
          hint: "poo_pee.date".tr(),
          items: feedTimeList,
          initialValue: _selectedItem,
          onChanged: _onChangeDate,
          label: "poo_pee.date".tr(),
        ),
        const SizedBox(
          height: AppTheme.spacing36,
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
