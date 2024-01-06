import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_baby/configs/theme.dart';
import 'package:my_baby/icons/my_flutter_app_icons.dart';
import 'package:my_baby/providers/growth_provider.dart';
import 'package:my_baby/utils/double_utils.dart';
import 'package:provider/provider.dart';

const double ITEM_SIZE = 70;

class SummaryBar extends StatelessWidget {
  const SummaryBar({super.key});

  @override
  Widget build(BuildContext context) {
    final weight = context.watch<GrowthProvider>().weight;
    final widgets = [
      SummaryItem(
        icon: CustomIcon.growth,
        text: (weight != null ? formatDouble(weight) : '-') + "growth.kg".tr(),
      ),
      // const SummaryItem(
      //   icon: CustomIcon.growth,
      //   text: "4.4kg",
      // ),
      // const SummaryItem(
      //   icon: CustomIcon.growth,
      //   text: "4.4kg",
      // ),
      // const SummaryItem(
      //   icon: CustomIcon.growth,
      //   text: "4.4kg",
      // ),
      // const SummaryItem(
      //   icon: CustomIcon.growth,
      //   text: "4.4kg",
      // ),
      // const SummaryItem(
      //   icon: CustomIcon.growth,
      //   text: "4.4kg",
      // ),
      // const SummaryItem(
      //   icon: CustomIcon.growth,
      //   text: "4.4kg",
      // ),
    ];
    return Container(
      height: ITEM_SIZE + (2 * AppTheme.spacing16),
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacing16),
      color: AppTheme.yellowShade.light.withOpacity(0.3),
      child: ListView.separated(
        // This next line does the trick.
        scrollDirection: Axis.horizontal,
        itemCount: widgets.length,
        itemBuilder: (context, index) {
          EdgeInsets? padding;
          if (index == widgets.length - 1) {
            padding = const EdgeInsets.only(right: AppTheme.spacing8);
          }
          if (index == 0) {
            padding = const EdgeInsets.only(left: AppTheme.spacing8);
          }
          return Container(padding: padding, child: widgets[index]);
        },
        separatorBuilder: (context, index) {
          return const SizedBox(
            width: AppTheme.spacing12,
          );
        },
      ),
    );
  }
}

class SummaryItem extends StatelessWidget {
  final IconData icon;
  final String text;
  const SummaryItem({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ITEM_SIZE,
      height: ITEM_SIZE,
      decoration: BoxDecoration(
          color: AppTheme.yellowShade.light,
          borderRadius: BorderRadius.circular(AppTheme.borderRadius8)),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24,
              color: AppTheme.yellowShade.dark,
            ),
            Text(
              text,
              style: ThemeTextStyle.paragraph3(context,
                  color: AppTheme.grayShade.shade01),
            ),
          ]),
    );
  }
}
