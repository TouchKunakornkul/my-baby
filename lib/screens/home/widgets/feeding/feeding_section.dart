import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_baby/configs/database.dart';
import 'package:my_baby/configs/theme.dart';
import 'package:my_baby/icons/custom_icons_icons.dart';
import 'package:my_baby/providers/feeding_provider.dart';
import 'package:my_baby/screens/home/widgets/feeding/add_feeding_dialog.dart';
import 'package:my_baby/screens/home/widgets/feeding/feeding_by_day_section.dart';
import 'package:my_baby/screens/home/widgets/feeding/feeding_routine_dialog.dart';
import 'package:my_baby/screens/home/widgets/growth/growth_infomation.dart';
import 'package:my_baby/utils/double_utils.dart';
import 'package:my_baby/widgets/base_information_bottom_sheet.dart';
import 'package:my_baby/widgets/base_section.dart';
import 'package:provider/provider.dart';

class FeedingSection extends StatelessWidget {
  const FeedingSection({super.key});

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
        subtitle:
            // nextFeedingTime != null
            //     ? Wrap(children: [
            //         Text(
            //           "feeding.subtitle".tr(args: [
            //             context.watch<FeedingProvider>().hourDuration.toString()
            //           ]),
            //           style: ThemeTextStyle.paragraph1(context,
            //               color: AppTheme.colorShade.text),
            //         ),
            //         Text(
            //           DateFormat('HH:mm').format(nextFeedingTime),
            //           style: ThemeTextStyle.boldParagraph1(context,
            //               color: AppTheme.colorShade.primary),
            //         ),
            //       ])
            //     : const SizedBox.shrink(),
            Row(
          children: [
            Text(
              "feeding.total_feed".tr(),
              style: ThemeTextStyle.paragraph3(context,
                  color: AppTheme.colorShade.text),
            ),
            const SizedBox(
              width: AppTheme.spacing8,
            ),
            Text(
              "${formatDouble(context.watch<FeedingProvider>().totalFeed)} ${"feeding.oz".tr()}",
              style: ThemeTextStyle.headline2(context,
                  color: AppTheme.colorShade.green),
            ),
          ],
        ),
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
        header: const SizedBox.shrink(),
        // Column(
        //   children: [
        //     Container(
        //       decoration: BoxDecoration(
        //         borderRadius: BorderRadius.circular(AppTheme.spacing8),
        //         color: AppTheme.colorShade.tertiary,
        //       ),
        //       padding: const EdgeInsets.symmetric(
        //         horizontal: AppTheme.spacing16,
        //         vertical: AppTheme.spacing8,
        //       ),
        //       child:
        //           Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        //         Text(
        //           "feeding.average".tr(),
        //           style: ThemeTextStyle.paragraph1(context,
        //               color: AppTheme.colorShade.text),
        //         ),
        //         const SizedBox(
        //           width: AppTheme.spacing16,
        //         ),
        //         Text(
        //           "feeding.oz_per_day".tr(args: [
        //             formatDouble(
        //                 context.watch<FeedingProvider>().averageAmountPerDay)
        //           ]),
        //           style: ThemeTextStyle.boldParagraph1(context,
        //               color: AppTheme.colorShade.text),
        //         ),
        //       ]),
        //     ),
        //   ],
        // ),
        hasDivider: false,
        content: ListView.builder(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount:
                context.watch<FeedingProvider>().feedingsByDay.keys.length,
            itemBuilder: (ctx, i) {
              final feedingsByDay = context
                  .watch<FeedingProvider>()
                  .feedingsByDay
                  .values
                  .toList()[i];
              if (feedingsByDay.isEmpty) {
                return const SizedBox.shrink();
              }
              return FeedingByDaySection(feedings: feedingsByDay);
            }));
  }
}
