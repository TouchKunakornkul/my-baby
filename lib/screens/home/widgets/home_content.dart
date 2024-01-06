import 'package:flutter/material.dart';
import 'package:my_baby/configs/theme.dart';
import 'package:my_baby/icons/my_flutter_app_icons.dart';
import 'package:my_baby/screens/home/widgets/growth_section.dart';
import 'package:my_baby/widgets/base_section.dart';

const double CONTENT_HEIGHT = 412;

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  List<Widget> get _widgets {
    return [const GrowthSection()];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: CONTENT_HEIGHT,
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacing12),
      color: AppTheme.grayShade.shade08.withOpacity(0.3),
      child: ListView.separated(
        // This next line does the trick.
        scrollDirection: Axis.horizontal,
        itemCount: _widgets.length,
        itemBuilder: (context, index) {
          EdgeInsets? padding;
          if (index == 0) {
            padding = const EdgeInsets.only(left: AppTheme.spacing12);
          } else if (index == _widgets.length - 1) {
            padding = const EdgeInsets.only(right: AppTheme.spacing12);
          }
          return Container(padding: padding, child: _widgets[index]);
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
