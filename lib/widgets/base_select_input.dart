import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_baby/configs/theme.dart';
import 'package:my_baby/icons/custom_icons_icons.dart';
import 'package:my_baby/widgets/base_bottom_sheet.dart';
import 'package:collection/collection.dart';

class BaseSelectInput extends StatefulWidget {
  final List<SelectItem> items;
  final Function(String) onChanged;
  final String hint;
  final String? initialValue;
  final bool disabled;
  final String label;
  final bool searchable;
  final String? searchHint;
  final bool innerLabel;

  const BaseSelectInput({
    Key? key,
    required this.items,
    required this.onChanged,
    required this.hint,
    this.initialValue,
    this.disabled = false,
    required this.label,
    this.searchable = false,
    this.searchHint,
    this.innerLabel = false,
  }) : super(key: key);

  @override
  _BaseSelectInputState createState() => _BaseSelectInputState();
}

class _BaseSelectInputState extends State<BaseSelectInput> {
  String value = '';

  @override
  void initState() {
    if (widget.initialValue != null) {
      value = widget.initialValue!;
    }
    super.initState();
  }

  void onChange(str) {
    setState(() {
      value = str;
    });
    widget.onChanged(str);
  }

  @override
  Widget build(BuildContext context) {
    SelectItem? selectedItem = value.isNotEmpty
        ? widget.items.firstWhereOrNull((item) => item.value == value)
        : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!widget.innerLabel)
          Text(widget.label,
              style: ThemeTextStyle.paragraph2(context,
                  color: AppTheme.grayShade.shade03)),
        if (!widget.innerLabel)
          const SizedBox(
            height: AppTheme.spacing2,
          ),
        GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              if (!widget.disabled) {
                BaseBottomSheet.showSelectableList(
                  context,
                  onSubmit: onChange,
                  title: widget.label,
                  value: value,
                  items: widget.items,
                  searchable: widget.searchable,
                  searchHint: widget.searchHint,
                );
              }
            },
            child: Container(
              height: 46,
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacing16,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppTheme.borderRadius4),
                border: Border.all(color: AppTheme.colorShade.border),
                color: Colors.white,
              ),
              child: (Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        if (widget.innerLabel)
                          Text(
                            "${widget.label} : ",
                            style: ThemeTextStyle.paragraph2(context,
                                color: AppTheme.grayShade.shade03),
                          ),
                        if (selectedItem != null && widget.innerLabel)
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(width: AppTheme.spacing12),
                            ],
                          ),
                        value.isEmpty
                            ? Expanded(
                                child: Text(
                                  widget.hint,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  softWrap: false,
                                  style: ThemeTextStyle.boldParagraph2(context,
                                      color: AppTheme.grayShade.shade03),
                                ),
                              )
                            : Expanded(
                                child: Text(
                                  widget.items
                                          .firstWhereOrNull(
                                              (item) => item.value == value)
                                          ?.label ??
                                      'common.no_data'.tr(),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  softWrap: false,
                                  style: widget.innerLabel
                                      ? ThemeTextStyle.boldParagraph1(context,
                                          color: AppTheme.colorShade.text)
                                      : ThemeTextStyle.paragraph1(context,
                                          color: AppTheme.colorShade.text),
                                ),
                              ),
                      ],
                    ),
                  ),
                  Icon(
                    CustomIcons.chevronDown,
                    size: 6,
                    color: AppTheme.colorShade.text,
                  ),
                ],
              )),
            )),
      ],
    );
  }
}
