
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_baby/configs/database.dart';
import 'package:my_baby/configs/theme.dart';
import 'package:my_baby/providers/feeding_provider.dart';
import 'package:my_baby/screens/home/widgets/feeding/edit_feeding_dialog.dart';
import 'package:my_baby/utils/double_utils.dart';

class FeedingByDaySection extends StatefulWidget {
  final List<Feeding> feedings;
  const FeedingByDaySection({super.key, required this.feedings});

  @override
  State<FeedingByDaySection> createState() => _FeedingByDaySectionState();
}

class _FeedingByDaySectionState extends State<FeedingByDaySection> {
  final ExpansionTileController controller = ExpansionTileController();

  double get _totalAmount {
    return widget.feedings.fold(0, (previousValue, element) {
      if (element.type == FeedingType.breast.name) {
        return previousValue;
      }
      return previousValue + element.amount;
    });
  }

  void _onEdit(BuildContext context, Feeding feeding) {
    showDialog(
        context: context,
        builder: (context) => EditFeedingDialog(feeding: feeding));
  }

  int calculateDifference(DateTime date) {
    DateTime now = DateTime.now();
    return DateTime(date.year, date.month, date.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
  }

  String get title {
    final diff = calculateDifference(widget.feedings[0].feedTime);
    if (diff == 0) {
      return "feeding.today".tr();
    } else if (diff == -1) {
      return "feeding.yesterday".tr();
    }
    return DateFormat('d MMM yyyy').format(widget.feedings[0].feedTime);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.feedings.isEmpty) {
      return const SizedBox.shrink();
    }
    return ExpansionTile(
      controller: controller,
      initiallyExpanded: calculateDifference(widget.feedings[0].feedTime) == 0,
      tilePadding: EdgeInsets.zero,
      title: Container(
        child: Table(
          columnWidths: const {
            0: FlexColumnWidth(0.4),
            1: FlexColumnWidth(0.3),
            2: FlexColumnWidth(0.3),
          },
          children: [
            TableRow(children: [
              Text(
                title,
                style: ThemeTextStyle.boldParagraph1(
                  context,
                  color: AppTheme.colorShade.text,
                ),
              ),
              Center(
                child: Text(
                  "${formatDouble(_totalAmount)} ${"feeding.oz".tr()}",
                  style: ThemeTextStyle.boldParagraph1(
                    context,
                    color: AppTheme.colorShade.text,
                  ),
                ),
              ),
              const SizedBox.shrink(),
            ]),
          ],
        ),
      ),
      children: <Widget>[
        Table(
          columnWidths: const {
            0: FlexColumnWidth(0.4),
            1: FlexColumnWidth(0.3),
            2: FlexColumnWidth(0.3),
            3: FixedColumnWidth(40),
          },
          children: widget.feedings.map((feeding) {
            final feedingType = stringToFeedingType(feeding.type);
            return TableRow(
              children: [
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppTheme.spacing8,
                    ),
                    child: InkWell(
                      onTap: () => _onEdit(context, feeding),
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
                        feeding.type == FeedingType.breast.name
                            ? "1 time"
                            : "${formatDouble(feeding.amount)} ${"feeding.oz".tr()}",
                        style: ThemeTextStyle.boldParagraph1(context,
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
                      child: Icon(
                        feedingType.icon,
                        size: feedingType.iconSize,
                      ),
                    ),
                  ),
                ),
                const SizedBox.shrink(),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}
