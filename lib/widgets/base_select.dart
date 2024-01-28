import 'package:flutter/material.dart';
import 'package:my_baby/configs/theme.dart';
import 'package:my_baby/icons/custom_icons_icons.dart';

class SelectItem {
  final String label;
  final String value;

  const SelectItem({
    Key? key,
    required this.label,
    required this.value,
  });
}

class BaseSelect extends StatelessWidget {
  final List<SelectItem> items;
  final Function(String) onChange;
  final String value;
  final String label;
  const BaseSelect({
    super.key,
    required this.items,
    required this.onChange,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final selectedItem = items.firstWhere((i) => i.value == value);
    final selectedIndex = items.indexWhere((i) => i.value == value);
    return Container(
      child: Column(children: [
        Text(
          label,
          style: ThemeTextStyle.boldParagraph4(
            context,
            color: AppTheme.grayShade.shade03,
          ),
        ),
        const SizedBox(
          height: AppTheme.spacing12,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
                onTap: () {
                  if (selectedIndex > 0) {
                    onChange(items[selectedIndex - 1].value);
                  }
                },
                child: Icon(
                  CustomIcons.left,
                  color: AppTheme.grayShade.shade05,
                )),
            Text(
              selectedItem.label,
              style: ThemeTextStyle.boldParagraph1(
                context,
                color: AppTheme.grayShade.shade01,
              ),
            ),
            GestureDetector(
                onTap: () {
                  if (selectedIndex < items.length - 1) {
                    onChange(items[selectedIndex + 1].value);
                  }
                },
                child:
                    Icon(CustomIcons.right, color: AppTheme.grayShade.shade05)),
          ],
        ),
      ]),
    );
  }
}
