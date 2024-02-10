import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_baby/configs/theme.dart';
import 'package:my_baby/widgets/base_dialog.dart';
import 'package:my_baby/widgets/base_text_input.dart';

class AddNoteDialog extends StatefulWidget {
  final Function(String) addNote;
  const AddNoteDialog({super.key, required this.addNote});

  @override
  State<AddNoteDialog> createState() => _AddNoteDialogState();
}

class _AddNoteDialogState extends State<AddNoteDialog> {
  final TextEditingController _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      title: 'note.add_title'.tr(),
      content: Column(children: [
        const SizedBox(
          height: AppTheme.spacing20,
        ),
        BaseTextInput(
          label: "note.note".tr(),
          type: InputType.multiline,
          maxLines: 3,
          minLines: 3,
          controller: _noteController,
          hintText: "note.note_placeholder".tr(),
          validator: (value) {
            if (value == null || value == "") {
              return "error.form_required".tr();
            }
            return null;
          },
        ),
      ]),
      okText: "common.+add".tr(),
      onOk: () {
        widget.addNote(_noteController.text);
      },
    );
  }
}
