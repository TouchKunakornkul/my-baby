import 'package:flutter/material.dart';
import 'package:my_baby/configs/theme.dart';

class GrowthInformation extends StatelessWidget {
  const GrowthInformation({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(AppTheme.spacing24),
        child: Column(
          children: [
            Text("Growth",
                style: ThemeTextStyle.headline1(
                  context,
                  color: AppTheme.secondaryShade.main,
                )),
            const Text(
                "Growth Assessment:\nIt helps track healthy development patterns and spot potential issues early on."),
            const Text(
                "Early Problem Detection:\nConsistent checks catch health concerns like malnutrition or growth disorders before they escalate."),
          ],
        ));
  }
}
