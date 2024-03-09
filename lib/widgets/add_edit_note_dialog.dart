import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_baby/configs/database.dart';
import 'package:my_baby/configs/theme.dart';
import 'package:my_baby/widgets/base_dialog.dart';
import 'package:my_baby/widgets/base_text_input.dart';

class AddEditNoteDialog extends StatefulWidget {
  final Function(String) addEditNote;
  final bool isEditMode;
  final Note? initialValue;
  final VoidCallback? onDelete;
  const AddEditNoteDialog(
      {super.key,
      required this.addEditNote,
      this.isEditMode = false,
      this.initialValue,
      this.onDelete});

  @override
  State<AddEditNoteDialog> createState() => _AddEditNoteDialogState();
}

class _AddEditNoteDialogState extends State<AddEditNoteDialog> {
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    if (widget.initialValue != null) {
      _noteController.text = widget.initialValue!.note;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      title: widget.isEditMode ? 'note.edit_title'.tr() : 'note.add_title'.tr(),
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
        if (widget.onDelete != null)
          Row(
            children: [
              InkWell(
                onTap: () {
                  widget.onDelete!();
                  Navigator.of(context).pop();
                },
                child: Text(
                  "note.delete_note".tr(),
                  style: ThemeTextStyle.paragraph3(context,
                      color: AppTheme.colorShade.error),
                ),
              ),
            ],
          ),
      ]),
      okText: widget.isEditMode ? "common.save".tr() : "common.+add".tr(),
      onOk: () {
        widget.addEditNote(_noteController.text);
      },
    );
  }
}
