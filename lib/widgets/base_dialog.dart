import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_baby/configs/theme.dart';
import 'package:my_baby/widgets/base_button.dart';

class BaseDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final String? okText;
  final VoidCallback? onOk;
  final VoidCallback? onClose;
  final String? cancelText;
  const BaseDialog({
    Key? key,
    required this.title,
    required this.content,
    this.onClose,
    this.cancelText,
    this.onOk,
    this.okText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      child: Stack(
        children: [
          // Positioned(
          //   top: 0,
          //   right: 0,
          //   child: InkWell(
          //     onTap: () {
          //       if (onClose != null) {
          //         onClose!();
          //       }
          //       Navigator.of(context).pop();
          //     },
          //     child: Ink(
          //         padding: const EdgeInsets.all(AppTheme.spacing16),
          //         child: Icon(
          //           CustomIcons.close,
          //           size: 18,
          //           color: AppTheme.grayShade.shade04,
          //         )),
          //   ),
          // ),
          Container(
            width: 325,
            color: AppTheme.grayShade.shade08,
            padding: const EdgeInsets.all(32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        textAlign: TextAlign.start,
                        style: ThemeTextStyle.boldParagraph1(context,
                            color: AppTheme.primaryShade.main),
                      ),
                      const SizedBox(
                        height: AppTheme.spacing6,
                      ),
                      content,
                      const SizedBox(
                        height: AppTheme.spacing24,
                      ),
                      Row(
                        mainAxisAlignment: onOk != null
                            ? MainAxisAlignment.spaceBetween
                            : MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 122,
                            child: BaseButton(
                              cancelText ?? 'common.close'.tr(),
                              type: onOk != null
                                  ? ButtonType.secondary
                                  : ButtonType.primary,
                              onPressed: () {
                                if (onClose != null) {
                                  onClose!();
                                }
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                          if (onOk != null)
                            SizedBox(
                              width: 122,
                              child: BaseButton(
                                okText ?? 'common.submit'.tr(),
                                onPressed: () {
                                  onOk!();
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
