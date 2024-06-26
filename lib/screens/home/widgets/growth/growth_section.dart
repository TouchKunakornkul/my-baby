import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_baby/configs/database.dart';
import 'package:my_baby/configs/theme.dart';
import 'package:my_baby/icons/custom_icons_icons.dart';
import 'package:my_baby/providers/growth_provider.dart';
import 'package:my_baby/screens/home/widgets/growth/add_growth_dialog.dart';
import 'package:my_baby/screens/home/widgets/growth/edit_growth_dialog.dart';
import 'package:my_baby/screens/home/widgets/growth/growth_chart.dart';
import 'package:my_baby/screens/home/widgets/growth/growth_infomation.dart';
import 'package:my_baby/utils/double_utils.dart';
import 'package:my_baby/widgets/base_information_bottom_sheet.dart';
import 'package:my_baby/widgets/base_section.dart';
import 'package:provider/provider.dart';

enum View {
  chart,
  table,
}

class GrowthSection extends StatefulWidget {
  const GrowthSection({super.key});

  @override
  State<GrowthSection> createState() => _GrowthSectionState();
}

class _GrowthSectionState extends State<GrowthSection> {
  View _view = View.chart;

  List<TableRow> _generateDataRow(BuildContext context) {
    final growths = context.watch<GrowthProvider>().growths;
    return growths
        .asMap()
        .map(
          (i, e) => MapEntry(
            i,
            TableRow(children: [
              Text(
                DateFormat('d MMM yyyy').format(e.createdAt),
                style: ThemeTextStyle.paragraph3(
                  context,
                  color: AppTheme.colorShade.placeholder,
                ),
              ),
              TableRowInkWell(
                onTap: () => _onEdit(context, e),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: AppTheme.spacing12),
                  child: Center(
                    child: Text(
                      formatDouble(e.weight) + "growth.kg".tr(),
                      style: i == 0
                          ? ThemeTextStyle.boldParagraph1(
                              context,
                              color: AppTheme.colorShade.text,
                            )
                          : ThemeTextStyle.paragraph1(
                              context,
                              color: AppTheme.colorShade.text,
                            ),
                    ),
                  ),
                ),
              ),
              TableRowInkWell(
                onTap: () => _onEdit(context, e),
                child: Center(
                  child: Text(
                    e.height != null
                        ? formatDouble(e.height!) + "growth.cm".tr()
                        : "-",
                    style: i == 0
                        ? ThemeTextStyle.boldParagraph1(
                            context,
                            color: AppTheme.colorShade.text,
                          )
                        : ThemeTextStyle.paragraph1(
                            context,
                            color: AppTheme.colorShade.text,
                          ),
                  ),
                ),
              ),
            ]),
          ),
        )
        .values
        .toList();
  }

  void _onEdit(BuildContext context, Growth growth) {
    showDialog(
        context: context,
        builder: (context) => EditGrowthDialog(growth: growth));
  }

  // List<TableRow> _generateDataRow(BuildContext context) {
  void _onAddGrowthNote(BuildContext context, String note) {
    context.read<GrowthProvider>().addGrowthNote(note: note);
  }

  void _onEditGrowthNote(BuildContext context, Note note) {
    context.read<GrowthProvider>().updateGrowthNote(note);
  }

  void _onDeleteGrowthNote(BuildContext context, Note note) {
    context.read<GrowthProvider>().deleteGrowthNote(note);
  }

  @override
  Widget build(BuildContext context) {
    final lastGrowthWeight = context.watch<GrowthProvider>().lastGrowthWeight;
    return BaseSection(
      icon: CustomIcons.growth,
      title: "growth.title".tr(),
      onAddNote: (note) => _onAddGrowthNote(context, note),
      onEditNote: (note) => _onEditGrowthNote(context, note),
      onDeleteNote: (note) => _onDeleteGrowthNote(context, note),
      notes: context.watch<GrowthProvider>().notes,
      subtitle: Text(
        "${lastGrowthWeight != null ? formatDouble(lastGrowthWeight) : "-"} ${"growth.kg".tr()}",
        style: ThemeTextStyle.headline2(
          context,
          color: AppTheme.colorShade.green,
        ),
      ),
      onClickBook: () {
        BaseInformationBottomSheet.show(context, const GrowthInformation());
      },
      onAdd: () {
        showDialog(
            context: context, builder: (context) => const AddGrowthDialog());
      },
      editable: context.watch<GrowthProvider>().growths.isNotEmpty,
      // onEdit: () {
      //   showDialog(
      //       context: context, builder: (context) => const EditGrowthDialog());
      // },
      header: const SizedBox.shrink(),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => setState(() {
              _view = _view == View.chart ? View.table : View.chart;
            }),
            child: Text(
              _view == View.chart
                  ? "growth.view_table".tr()
                  : "growth.view_chart".tr(),
              style: ThemeTextStyle.paragraph1(
                context,
                color: AppTheme.colorShade.primary,
              ),
            ),
          ),
          if (_view == View.chart)
            GrowthChart(
              growths: context.watch<GrowthProvider>().growths,
            ),
          if (_view == View.table)
            Table(
              columnWidths: const {
                0: FractionColumnWidth(0.4), // 40%
                1: FractionColumnWidth(0.3), // 30%
                2: FractionColumnWidth(0.3), // 30%
              },
              children: _generateDataRow(context),
            ),
        ],
      ),
    );
  }
}
