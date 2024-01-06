import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_baby/configs/theme.dart';
import 'package:my_baby/icons/my_flutter_app_icons.dart';
import 'package:my_baby/providers/growth_provider.dart';
import 'package:my_baby/screens/home/widgets/add_growth_dialog.dart';
import 'package:my_baby/screens/home/widgets/edit_growth_dialog.dart';
import 'package:my_baby/screens/home/widgets/growth_infomation.dart';
import 'package:my_baby/utils/double_utils.dart';
import 'package:my_baby/widgets/base_information_bottom_sheet.dart';
import 'package:my_baby/widgets/base_section.dart';
import 'package:provider/provider.dart';

class GrowthSection extends StatelessWidget {
  const GrowthSection({super.key});

  List<TableRow> _generateDataRow(BuildContext context) {
    return context
        .watch<GrowthProvider>()
        .growths
        .map((e) => TableRow(children: [
              Padding(
                padding: const EdgeInsets.only(bottom: AppTheme.spacing12),
                child: Text(
                  DateFormat('d MMM yyyy').format(e.createdAt),
                  style: ThemeTextStyle.paragraph4(
                    context,
                    color: AppTheme.grayShade.shade04,
                  ),
                ),
              ),
              Center(
                child: Text(
                  formatDouble(e.weight) + "growth.kg".tr(),
                  style: ThemeTextStyle.paragraph4(
                    context,
                    color: AppTheme.grayShade.shade01,
                  ),
                ),
              ),
              Center(
                child: Text(
                  e.height != null
                      ? formatDouble(e.height!) + "growth.cm".tr()
                      : "-",
                  style: ThemeTextStyle.paragraph4(
                    context,
                    color: AppTheme.grayShade.shade01,
                  ),
                ),
              ),
            ]))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final growthRate = context.watch<GrowthProvider>().growthRate;
    return BaseSection(
      icon: CustomIcon.growth,
      title: "growth.title".tr(),
      bgColor: AppTheme.redShade.light,
      subtitle: growthRate != null
          ? "growth.subtitle".tr(args: [growthRate.toStringAsFixed(0)])
          : '-',
      onClickBook: () {
        BaseInformationBottomSheet.show(context, const GrowthInformation());
      },
      onAdd: () {
        showDialog(
            context: context, builder: (context) => const AddGrowthDialog());
      },
      editable: context.watch<GrowthProvider>().growths.isNotEmpty,
      onEdit: () {
        showDialog(
            context: context, builder: (context) => const EditGrowthDialog());
      },
      header: Table(columnWidths: const {
        0: FractionColumnWidth(0.5), // 50%
        1: FractionColumnWidth(0.25), // 25%
        2: FractionColumnWidth(0.25), // 25%
      }, children: [
        TableRow(children: [
          const SizedBox.shrink(),
          Center(
              child: Padding(
            padding: const EdgeInsets.only(bottom: AppTheme.spacing12),
            child: Text(
              "growth.weight".tr(),
              style: ThemeTextStyle.paragraph4(
                context,
                color: AppTheme.grayShade.shade04,
              ),
            ),
          )),
          Center(
            child: Text(
              "growth.height".tr(),
              style: ThemeTextStyle.paragraph4(
                context,
                color: AppTheme.grayShade.shade04,
              ),
            ),
          ),
        ]),
      ]),
      content: Table(
        columnWidths: const {
          0: FractionColumnWidth(0.5), // 50%
          1: FractionColumnWidth(0.25), // 25%
          2: FractionColumnWidth(0.25), // 25%
        },
        children: _generateDataRow(context),
      ),
    );
  }
}
