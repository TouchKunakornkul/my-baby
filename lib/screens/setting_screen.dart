import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_baby/configs/theme.dart';
import 'package:my_baby/icons/custom_icons_icons.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: AppTheme.spacing16, right: AppTheme.spacing16),
                  child: InkWell(
                      onTap: () => context.go('/home'),
                      child: const Padding(
                        padding: EdgeInsets.all(AppTheme.spacing4),
                        child: Icon(
                          CustomIcons.close,
                          size: 16,
                        ),
                      )),
                ),
                Text(
                  'setting.title'.tr(),
                  style: ThemeTextStyle.headline1(context,
                      color: AppTheme.colorShade.text),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
