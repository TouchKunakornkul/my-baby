import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:my_baby/configs/theme.dart';
import 'package:my_baby/icons/custom_icons_icons.dart';
import 'package:my_baby/providers/app_provider.dart';
import 'package:my_baby/providers/child_provider.dart';
import 'package:my_baby/providers/feeding_provider.dart';
import 'package:my_baby/providers/growth_provider.dart';
import 'package:my_baby/providers/poo_pee_provider.dart';
import 'package:my_baby/providers/stock_provider.dart';
import 'package:my_baby/widgets/base_alert.dart';
import 'package:my_baby/widgets/base_switch.dart';
import 'package:provider/provider.dart';

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _Section({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: AppTheme.spacing20),
          child: Text(
            title,
            style: ThemeTextStyle.boldParagraph3(
              context,
              color: AppTheme.colorShade.placeholder,
            ),
          ),
        ),
        const SizedBox(
          height: AppTheme.spacing12,
        ),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.colorShade.background,
            borderRadius: BorderRadius.circular(20),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: children.length,
            itemBuilder: (context, i) => Container(
              padding: const EdgeInsets.all(AppTheme.spacing24),
              child: children[i],
            ),
            separatorBuilder: (context, index) => const Divider(
              height: 1,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  Future<void> _onResetData(BuildContext context) async {
    await context.read<AppProvider>().resetData();
    context.read<GrowthProvider>().reset();
    context.read<FeedingProvider>().reset();
    context.read<StockProvider>().reset();
    context.read<PooPeeProvider>().reset();
    context.go('/');
  }

  _showAlertDialog(BuildContext context) async {
    showDialog(
        context: context,
        builder: (ctx) => BaseAlert(
              title: 'setting.reset_data_title'.tr(),
              content: Text(
                'setting.reset_data_description'.tr(),
                style: ThemeTextStyle.paragraph2(context,
                    color: AppTheme.colorShade.error),
              ),
              okText: "setting.reset_data".tr(),
              onOk: () => _onResetData(context),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  right: 0,
                  child: Padding(
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
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(
                    left: AppTheme.spacing12,
                    top: AppTheme.spacing32,
                    right: AppTheme.spacing12,
                    bottom: AppTheme.spacing16,
                  ),
                  child: Column(
                    children: [
                      Text(
                        'setting.title'.tr(),
                        style: ThemeTextStyle.headline1(context,
                            color: AppTheme.colorShade.text),
                      ),
                      const SizedBox(
                        height: AppTheme.spacing20,
                      ),
                      _Section(
                        title: "setting.alert_and_display".tr(),
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "setting.notification".tr(),
                                style: ThemeTextStyle.paragraph1(
                                  context,
                                  color: AppTheme.colorShade.text,
                                ),
                              ),
                              BaseSwitch(
                                onChanged: (value) {
                                  context
                                      .read<AppProvider>()
                                      .setNotification(value);
                                },
                                value: context
                                    .watch<AppProvider>()
                                    .notificationEnabled,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: AppTheme.spacing36,
                      ),
                      _Section(
                        title: "setting.data".tr(),
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                context.watch<ChildProvider>().child?.name ??
                                    '',
                                style: ThemeTextStyle.paragraph1(
                                  context,
                                  color: AppTheme.colorShade.primary,
                                ),
                              ),
                              // Icon(
                              //   CustomIcons.chevronRight,
                              //   size: 20,
                              //   color: AppTheme.colorShade.placeholder,
                              // ),
                            ],
                          ),
                          InkWell(
                            onTap: () => _showAlertDialog(context),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "setting.reset_all_data".tr(),
                                  style: ThemeTextStyle.paragraph1(
                                    context,
                                    color: AppTheme.colorShade.error,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: AppTheme.spacing36,
                      ),
                      _Section(
                        title: "setting.about_us".tr(),
                        children: [
                          InkWell(
                            onTap: () => context.go('/support'),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "setting.about_us".tr(),
                                  style: ThemeTextStyle.paragraph1(
                                    context,
                                    color: AppTheme.colorShade.text,
                                  ),
                                ),
                                Icon(
                                  CustomIcons.chevronRight,
                                  size: 20,
                                  color: AppTheme.colorShade.placeholder,
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              final InAppReview inAppReview =
                                  InAppReview.instance;
                              await inAppReview.openStoreListing(
                                appStoreId: "6474651275",
                              );

                              if (await inAppReview.isAvailable()) {
                                inAppReview.requestReview();
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "setting.feedback_us".tr(),
                                  style: ThemeTextStyle.paragraph1(
                                    context,
                                    color: AppTheme.colorShade.text,
                                  ),
                                ),
                                Icon(
                                  CustomIcons.chevronRight,
                                  size: 20,
                                  color: AppTheme.colorShade.placeholder,
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("setting.contact_us".tr(),
                                  style: ThemeTextStyle.paragraph1(
                                    context,
                                    color: AppTheme.colorShade.text,
                                  )),
                              Text(
                                "setting.contact_email".tr(),
                                style: ThemeTextStyle.paragraph1(
                                  context,
                                  color: AppTheme.colorShade.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: AppTheme.spacing36,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "setting.app_version".tr(args: [
                              context.read<AppProvider>().packageInfo.version
                            ]),
                            style: ThemeTextStyle.paragraph3(
                              context,
                              color: AppTheme.colorShade.placeholder,
                            ),
                          ),
                        ],
                      ),
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
