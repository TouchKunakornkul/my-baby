import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_baby/configs/theme.dart';

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
          Container(
            width: 332,
            color: AppTheme.grayShade.shade08,
            padding: const EdgeInsets.all(AppTheme.spacing24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                if (onClose != null) {
                                  onClose!();
                                }
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                cancelText ?? 'common.cancel'.tr(),
                                textAlign: TextAlign.start,
                                style: ThemeTextStyle.paragraph1(context,
                                    color: AppTheme.colorShade.secondary),
                              ),
                            ),
                          ),
                          Text(
                            title,
                            textAlign: TextAlign.start,
                            style: ThemeTextStyle.boldParagraph1(context,
                                color: AppTheme.colorShade.text),
                          ),
                          Expanded(
                            child: onOk != null
                                ? InkWell(
                                    onTap: () {
                                      if (onOk != null) {
                                        onOk!();
                                      }
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      okText ?? 'common.submit'.tr(),
                                      textAlign: TextAlign.end,
                                      style: ThemeTextStyle.paragraph1(context,
                                          color: AppTheme.colorShade.primary),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: AppTheme.spacing6,
                      ),
                      content,
                      // const SizedBox(
                      //   height: AppTheme.spacing8,
                      // ),
                      // Row(
                      //   mainAxisAlignment: onOk != null
                      //       ? MainAxisAlignment.spaceBetween
                      //       : MainAxisAlignment.center,
                      //   children: [
                      //     SizedBox(
                      //       width: onOk != null ? 142 : 284,
                      //       child: BaseButton(
                      //         cancelText ?? 'common.close'.tr(),
                      //         type: onOk != null
                      //             ? ButtonType.secondary
                      //             : ButtonType.primary,
                      //         onPressed: () {
                      //           if (onClose != null) {
                      //             onClose!();
                      //           }
                      //           Navigator.of(context).pop();
                      //         },
                      //       ),
                      //     ),
                      //     if (onOk != null)
                      //       SizedBox(
                      //         width: 142,
                      //         child: BaseButton(
                      //           okText ?? 'common.submit'.tr(),
                      //           onPressed: () {
                      //             onOk!();
                      //             Navigator.of(context).pop();
                      //           },
                      //         ),
                      //       ),
                      //   ],
                      // )
                    ],
                  ),
                ),
              ],
            ),
          ),
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
          //           color: AppTheme.colorShade.text,
          //         )),
          //   ),
          // ),
        ],
      ),
    );
  }
}
