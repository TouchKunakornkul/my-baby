import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_baby/configs/theme.dart';
import 'package:my_baby/icons/custom_icons_icons.dart';
import 'package:my_baby/widgets/base_button.dart';

class BaseAlert extends StatelessWidget {
  final String title;
  final Widget content;
  final String? okText;
  final VoidCallback? onOk;
  final VoidCallback? onClose;
  const BaseAlert({
    Key? key,
    required this.title,
    required this.content,
    this.onClose,
    this.onOk,
    this.okText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      child: Stack(
        children: [
          Container(
            width: 332,
            height: 243,
            color: AppTheme.grayShade.shade08,
            padding: const EdgeInsets.all(AppTheme.spacing24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            title,
                            textAlign: TextAlign.start,
                            style: ThemeTextStyle.headline3(context,
                                color: AppTheme.colorShade.text),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: AppTheme.spacing6,
                      ),
                      content,
                      const SizedBox(
                        height: AppTheme.spacing8,
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: onOk != null
                      ? MainAxisAlignment.spaceBetween
                      : MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          BaseButton(
                            okText ?? 'common.submit'.tr(),
                            type: ButtonType.error,
                            onPressed: () {
                              onOk!();
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: InkWell(
              onTap: () {
                if (onClose != null) {
                  onClose!();
                }
                Navigator.of(context).pop();
              },
              child: Ink(
                  padding: const EdgeInsets.all(AppTheme.spacing16),
                  child: Icon(
                    CustomIcons.close,
                    size: 18,
                    color: AppTheme.colorShade.text,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
