import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_baby/configs/theme.dart';
import 'package:my_baby/icons/my_flutter_app_icons.dart';
import 'package:my_baby/providers/child_provider.dart';
import 'package:my_baby/widgets/base_date_picker.dart';
import 'package:my_baby/widgets/base_dialog.dart';
import 'package:my_baby/widgets/base_text_input.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

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
    _imageUrl = context.read<ChildProvider>().child?.imageUrl ??
        'https://picsum.photos/450/770';
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
      title: ''.tr(),
      content: Column(children: [
        ClipOval(
          child: Stack(children: [
            if (_imageUrl != "")
              Image.network(
                // placeholder: kTransparentImage,
                _imageUrl,
                height: 120,
                width: 120,
                fit: BoxFit.cover,
              ),
            GestureDetector(
              onTap: () async {
                if (_picker.supportsImageSource(ImageSource.gallery)) {
                  final XFile? image =
                      await _picker.pickImage(source: ImageSource.gallery);
                  final directory = await getApplicationDocumentsDirectory();
                  // final newFile =
                  //     File("${directory.path}/${image?.name ?? ''}");
                  if (image != null) {
                    final byte = await image.readAsBytes();
                    // newFile.writeAsBytes(byte);
                    // // getting a directory path for saving
                    // final Directory directory =
                    //     await getApplicationDocumentsDirectory();
                    // final imagePathname = newFile.path;
                    print(image.path);
                    // print(directory.path);

                    setState(() {
                      _imageUrl = image.path;
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
                    CustomIcon.muscle,
                    color: AppTheme.grayShade.shade08,
                  ),
                ),
              ),
            )
          ]),
        ),
        BaseTextInput(
          controller: _nameController,
        ),
        BaseDatePicker(
          value: _birthDate,
          onChange: (date) {
            setState(() {
              _birthDate = date;
            });
          },
        )
      ]),
      onOk: _updateChild,
    );
  }
}
