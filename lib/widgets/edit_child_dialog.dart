import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_baby/configs/theme.dart';
import 'package:my_baby/icons/custom_icons_icons.dart';
import 'package:my_baby/providers/child_provider.dart';
import 'package:my_baby/widgets/base_date_picker.dart';
import 'package:my_baby/widgets/base_dialog.dart';
import 'package:my_baby/widgets/base_text_input.dart';
import 'package:my_baby/widgets/child_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class EditChildDialog extends StatefulWidget {
  const EditChildDialog({super.key});

  @override
  State<EditChildDialog> createState() => _EditChildDialogState();
}

class _EditChildDialogState extends State<EditChildDialog> {
  String _imageUrl = "";
  final TextEditingController _nameController = TextEditingController();
  late DateTime _birthDate;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    _imageUrl = context.read<ChildProvider>().child?.imageUrl ?? "";
    _birthDate =
        context.read<ChildProvider>().child?.birthDate ?? DateTime.now();
    _nameController.text = context.read<ChildProvider>().child?.name ?? "";
    super.initState();
  }

  Future<void> _updateChild() async {
    await context.read<ChildProvider>().updateChild(
          name: _nameController.text,
          imageUrl: _imageUrl,
          birthDate: _birthDate,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      title: 'edit_child_dialog.title'.tr(),
      content: Column(children: [
        const SizedBox(
          height: AppTheme.spacing32,
        ),
        ClipOval(
          child: Stack(children: [
            ChildImage(
              imageUrl: _imageUrl,
              height: 120,
              width: 120,
            ),
            GestureDetector(
              onTap: () async {
                if (_picker.supportsImageSource(ImageSource.gallery)) {
                  final XFile? image =
                      await _picker.pickImage(source: ImageSource.gallery);
                  final directory = await getApplicationDocumentsDirectory();
                  final newPath = "${directory.path}/${image?.name ?? ''}";
                  final newFile = File(newPath);
                  if (image != null) {
                    final byte = await image.readAsBytes();
                    newFile.writeAsBytes(byte);
                    setState(() {
                      _imageUrl = newPath;
                    });
                  }
                }
              },
              child: Container(
                color: AppTheme.grayShade.shade01.withOpacity(0.3),
                height: 120,
                width: 120,
                child: Center(
                  child: Icon(
                    CustomIcons.camera,
                    color: AppTheme.grayShade.shade08,
                  ),
                ),
              ),
            )
          ]),
        ),
        const SizedBox(
          height: AppTheme.spacing24,
        ),
        BaseTextInput(
          label: "edit_child_dialog.display_name".tr(),
          controller: _nameController,
          validator: (value) {
            if (value == null || value == "") {
              return "error.form_required".tr();
            }
            return null;
          },
        ),
        BaseDatePicker(
          label: "edit_child_dialog.date_of_birth".tr(),
          value: _birthDate,
          onChange: (date) {
            setState(() {
              _birthDate = date;
            });
          },
        )
      ]),
      okText: "common.save".tr(),
      onOk: _updateChild,
    );
  }
}
