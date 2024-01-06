import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_baby/configs/theme.dart';
import 'package:my_baby/icons/my_flutter_app_icons.dart';
import 'package:my_baby/widgets/base_button.dart';

const double CONTENT_WIDTH = 340;

class BaseSection extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color bgColor;
  final VoidCallback onClickBook;
  final VoidCallback onAdd;
  final VoidCallback onEdit;
  final bool editable;
  final Widget content;
  final Widget header;
  const BaseSection({
    super.key,
    required this.icon,
    required this.title,
    required this.bgColor,
    required this.subtitle,
    required this.onClickBook,
    required this.content,
    required this.onAdd,
    required this.onEdit,
    this.editable = true,
    required this.header,
  });

  @override
  State<BaseSection> createState() => _BaseSectionState();
}

class _BaseSectionState extends State<BaseSection> {
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 100));
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.bgColor,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius20),
      ),
      width: CONTENT_WIDTH,
      padding: const EdgeInsets.all(AppTheme.spacing20),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  widget.icon,
                  size: 24,
                ),
                const SizedBox(
                  width: AppTheme.spacing8,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: ThemeTextStyle.boldParagraph1(context,
                          color: AppTheme.secondaryShade.main),
                    ),
                    Text(
                      widget.subtitle,
                      style: ThemeTextStyle.paragraph4(context,
                          color: AppTheme.secondaryShade.light),
                    ),
                  ],
                )
              ],
            ),
            InkWell(
              onTap: widget.onClickBook,
              child: const Icon(
                CustomIcon.book,
                size: 24,
              ),
            )
          ],
        ),
        const SizedBox(
          height: AppTheme.spacing20,
        ),
        widget.header,
        Expanded(
            child: Scrollbar(
                thumbVisibility: true,
                controller: _scrollController,
                child: SingleChildScrollView(
                    controller: _scrollController, child: widget.content))),
        const SizedBox(
          height: AppTheme.spacing20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            BaseButton(
              "common.edit".tr(),
              disabled: !widget.editable,
              onPressed: widget.onEdit,
              buttonBorder: ButtonBorder.circular,
              type: ButtonType.secondary,
            ),
            const SizedBox(
              width: AppTheme.spacing10,
            ),
            BaseButton(
              "common.add".tr(),
              onPressed: widget.onAdd,
              buttonBorder: ButtonBorder.circular,
            ),
          ],
        )
      ]),
    );
  }
}
