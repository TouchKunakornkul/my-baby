import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_baby/configs/database.dart';
import 'package:my_baby/configs/theme.dart';
import 'package:my_baby/icons/custom_icons_icons.dart';
import 'package:my_baby/providers/feeding_provider.dart';
import 'package:my_baby/screens/home/widgets/feeding/add_feeding_dialog.dart';
import 'package:my_baby/screens/home/widgets/feeding/edit_feeding_dialog.dart';
import 'package:my_baby/screens/home/widgets/feeding/feeding_routine_dialog.dart';
import 'package:my_baby/screens/home/widgets/growth/growth_infomation.dart';
import 'package:my_baby/utils/double_utils.dart';
import 'package:my_baby/widgets/base_information_bottom_sheet.dart';
import 'package:my_baby/widgets/base_section.dart';
import 'package:provider/provider.dart';

class FeedingSection extends StatelessWidget {
  const FeedingSection({super.key});

  void _onEdit(BuildContext context, Feeding feeding) {
    showDialog(
        context: context,
        builder: (context) => EditFeedingDialog(feeding: feeding));
  }

  List<TableRow> _generateDataRow(BuildContext context) {
    final feedingsByDay = context.watch<FeedingProvider>().feedingsByDay;
    final List<TableRow> widgets = [];
    for (var element in feedingsByDay.entries) {
      for (var i = 0; i < element.value.length; i++) {
        double sumOuncesPerDay = 0.0;
        for (var i = 0; i < element.value.length; i++) {
          sumOuncesPerDay += element.value[i].amount;
        }
        final feeding = element.value[i];
        final feedingType = stringToFeedingType(feeding.type);
        widgets.add(TableRow(children: [
          ...(i == 0
              ? [
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.middle,
                    child: Center(
                      child: Text(
                        DateFormat('d MMM').format(feeding.feedTime),
                        style: ThemeTextStyle.paragraph3(context,
                            color: AppTheme.colorShade.placeholder),
                      ),
                    ),
                  ),
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.middle,
                    child: Center(
                      child: Text(
                        formatDouble(sumOuncesPerDay),
                        style: ThemeTextStyle.boldParagraph1(context,
                            color: AppTheme.colorShade.text),
                      ),
                    ),
                  ),
                ]
              : [
                  const SizedBox.shrink(),
                  const SizedBox.shrink(),
                ]),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: InkWell(
              onTap: () => _onEdit(context, feeding),
              child: Center(
                child: Icon(
                  feedingType.icon,
                  size: feedingType.iconSize,
                ),
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: InkWell(
              onTap: () => _onEdit(context, feeding),
              child: Center(
                child: Text(
                  DateFormat('HH:mm').format(feeding.feedTime),
                  style: ThemeTextStyle.paragraph1(context,
                      color: AppTheme.colorShade.text),
                ),
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: InkWell(
              onTap: () => _onEdit(context, feeding),
              child: Center(
                child: Text(
                  formatDouble(feeding.amount),
                  style: ThemeTextStyle.boldParagraph1(context,
                      color: AppTheme.colorShade.text),
                ),
              ),
            ),
          ),
        ]));

        widgets.add(const TableRow(children: [
          SizedBox(
            height: AppTheme.spacing20,
          ),
          SizedBox.shrink(),
          SizedBox.shrink(),
          SizedBox.shrink(),
          SizedBox.shrink(),
        ]));
      }
    }
    return widgets;
  }

  void _onAddFeedingNote(BuildContext context, String note) {
    context.read<FeedingProvider>().addFeedingNote(note);
  }

  void _onEditFeedingNote(BuildContext context, Note note) {
    context.read<FeedingProvider>().updateFeedingNote(note);
  }

  void _onDeleteFeedingNote(BuildContext context, Note note) {
    context.read<FeedingProvider>().deleteFeedingNote(note);
  }

  @override
  Widget build(BuildContext context) {
    final nextFeedingTime = context.watch<FeedingProvider>().nextFeedingTime;
    return BaseSection(
      notes: context.watch<FeedingProvider>().notes,
      icon: CustomIcons.growth,
      title: "feeding.title".tr(),
      subtitle: nextFeedingTime != null
          ? Wrap(children: [
              Text(
                "feeding.subtitle".tr(args: [
                  context.watch<FeedingProvider>().hourDuration.toString()
                ]),
                style: ThemeTextStyle.paragraph1(context,
                    color: AppTheme.colorShade.text),
              ),
              Text(
                DateFormat('HH:mm').format(nextFeedingTime),
                style: ThemeTextStyle.boldParagraph1(context,
                    color: AppTheme.colorShade.primary),
              ),
            ])
          : const SizedBox.shrink(),
      onAddNote: (note) => _onAddFeedingNote(context, note),
      onEditNote: (note) => _onEditFeedingNote(context, note),
      onDeleteNote: (note) => _onDeleteFeedingNote(context, note),
      onSetRoutine: () {
        showDialog(
            context: context,
            builder: (context) => const FeedingRoutineDialog());
      },
      onClickBook: () {
        BaseInformationBottomSheet.show(context, const GrowthInformation());
      },
      onAdd: () {
        showDialog(
            context: context, builder: (context) => const AddFeedingDialog());
      },
      editable: context.watch<FeedingProvider>().feedings.isNotEmpty,
      // onEdit: () {
      //   showDialog(
      //       context: context, builder: (context) => const EditFeedingDialog());
      // },
      header: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppTheme.spacing8),
              color: AppTheme.colorShade.tertiary,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacing16,
              vertical: AppTheme.spacing8,
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                "feeding.average".tr(),
                style: ThemeTextStyle.paragraph1(context,
                    color: AppTheme.colorShade.text),
              ),
              const SizedBox(
                width: AppTheme.spacing16,
              ),
              Text(
                "feeding.oz_per_day".tr(args: [
                  formatDouble(
                      context.watch<FeedingProvider>().averageAmountPerDay)
                ]),
                style: ThemeTextStyle.boldParagraph1(context,
                    color: AppTheme.colorShade.text),
              ),
            ]),
          ),
          const SizedBox(height: AppTheme.spacing20),
          Table(
            // columnWidths: const {
            //   0: FractionColumnWidth(0.20), // 20%
            //   1: FractionColumnWidth(0.20), // 20%
            //   2: FractionColumnWidth(0.20), // 20%
            //   3: FractionColumnWidth(0.20), // 20%
            // },
            children: [
              TableRow(children: [
                const SizedBox.shrink(),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: AppTheme.spacing12),
                    child: Text(
                      "feeding.daily".tr(),
                      style: ThemeTextStyle.boldParagraph3(
                        context,
                        color: AppTheme.colorShade.placeholder,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    "feeding.type_label".tr(),
                    style: ThemeTextStyle.boldParagraph3(
                      context,
                      color: AppTheme.colorShade.placeholder,
                    ),
                  ),
                ),
                Center(
                    child: Padding(
                  padding: const EdgeInsets.only(bottom: AppTheme.spacing12),
                  child: Text(
                    "feeding.feed_time".tr(),
                    style: ThemeTextStyle.boldParagraph3(
                      context,
                      color: AppTheme.colorShade.placeholder,
                    ),
                  ),
                )),
                Center(
                    child: Padding(
                  padding: const EdgeInsets.only(bottom: AppTheme.spacing12),
                  child: Text(
                    "(${"feeding.ounce".tr()})",
                    style: ThemeTextStyle.boldParagraph3(
                      context,
                      color: AppTheme.colorShade.placeholder,
                    ),
                  ),
                )),
              ]),
            ],
          ),
        ],
      ),
      content: Table(
        // columnWidths: const {
        //   0: FractionColumnWidth(0.4), // 40%
        //   1: FractionColumnWidth(0.3), // 30%
        //   2: FractionColumnWidth(0.3), // 30%
        // },
        children: _generateDataRow(context),
      ),
    );
  }
}
