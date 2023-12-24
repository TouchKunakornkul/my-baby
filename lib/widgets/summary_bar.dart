import 'package:flutter/material.dart';
import 'package:my_baby/configs/theme.dart';
import 'package:my_baby/icons/my_flutter_app_icons.dart';

const double ITEM_SIZE = 70;

class SummaryBar extends StatelessWidget {
  const SummaryBar({super.key});

  List<Widget> get _widgets {
    return [
      const SummaryItem(
        icon: CustomIcon.growth,
        text: "4.4kg",
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ITEM_SIZE + (2 * AppTheme.spacing16),
      padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacing8, vertical: AppTheme.spacing16),
      color: AppTheme.grayShade.shade08.withOpacity(0.3),
      child: ListView.separated(
        // This next line does the trick.
        scrollDirection: Axis.horizontal,
        itemCount: _widgets.length,
        itemBuilder: (context, index) {
          return _widgets[index];
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
          color: AppTheme.primaryShade.light,
          borderRadius: BorderRadius.circular(AppTheme.borderRadius8)),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24,
              color: AppTheme.primaryShade.main,
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
