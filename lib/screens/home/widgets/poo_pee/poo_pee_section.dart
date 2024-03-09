import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_baby/configs/database.dart';
import 'package:my_baby/configs/theme.dart';
import 'package:my_baby/icons/custom_icons_icons.dart';
import 'package:my_baby/models/poo_pee_model.dart';
import 'package:my_baby/providers/poo_pee_provider.dart';
import 'package:my_baby/screens/home/widgets/growth/growth_infomation.dart';
import 'package:my_baby/screens/home/widgets/poo_pee/add_poo_pee_dialog.dart';
import 'package:my_baby/screens/home/widgets/poo_pee/edit_poo_pee_dialog.dart';
import 'package:my_baby/widgets/base_information_bottom_sheet.dart';
import 'package:my_baby/widgets/base_section.dart';
import 'package:provider/provider.dart';

class PooPeeSection extends StatelessWidget {
  const PooPeeSection({super.key});

  void _onEdit(BuildContext context, PooPee pooPee) {
    showDialog(
        context: context,
        builder: (context) => EditPooPeeDialog(pooPee: pooPee));
  }

  List<TableRow> _generateDataRow(BuildContext context) {
    final pooPeesByDay = context.watch<PooPeeProvider>().pooPeesByDay;
    final List<TableRow> widgets = [];
    for (var element in pooPeesByDay.entries) {
      for (var i = 0; i < element.value.length; i++) {
        final pooPee = element.value[i];
        widgets.add(TableRow(children: [
          i == 0
              ? TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,
                  child: Center(
                    child: Text(
                      DateFormat('d MMM').format(pooPee.createdAt),
                      style: ThemeTextStyle.paragraph3(context,
                          color: AppTheme.colorShade.placeholder),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: InkWell(
              onTap: () => _onEdit(context, pooPee),
              child: Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: AppTheme.spacing2),
                  child: Text(
                    DateFormat('HH:mm').format(pooPee.createdAt),
                    style: ThemeTextStyle.paragraph1(context,
                        color: AppTheme.colorShade.text),
                  ),
                ),
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: InkWell(
              onTap: () => _onEdit(context, pooPee),
              child: Center(
                child: Text(
                  stringToPooPeeType(pooPee.type).label,
                  style: ThemeTextStyle.boldParagraph1(context,
                      color: AppTheme.colorShade.text),
                ),
              ),
            ),
          ),
        ]));
      }
    }
    return widgets;
  }

  void _onAddPooPeeNote(BuildContext context, String note) {
    context.read<PooPeeProvider>().addPooPeeNote(note);
  }

  void _onEditPooPeeNote(BuildContext context, Note note) {
    context.read<PooPeeProvider>().updatePooPeeNote(note);
  }

  void _onDeletePooPeeNote(BuildContext context, Note note) {
    context.read<PooPeeProvider>().deletePooPeeNote(note);
  }

  @override
  Widget build(BuildContext context) {
    final pooCount = context.watch<PooPeeProvider>().pooCount;
    final peeCount = context.watch<PooPeeProvider>().peeCount;
    return BaseSection(
      notes: context.watch<PooPeeProvider>().notes,
      icon: CustomIcons.growth,
      title: "poo_pee.title".tr(),
      subtitle: const SizedBox.shrink(),
      onAddNote: (note) => _onAddPooPeeNote(context, note),
      onEditNote: (note) => _onEditPooPeeNote(context, note),
      onDeleteNote: (note) => _onDeletePooPeeNote(context, note),
      onClickBook: () {
        BaseInformationBottomSheet.show(context, const GrowthInformation());
      },
      onAdd: () {
        showDialog(
            context: context, builder: (context) => const AddPooPeeDialog());
      },
      editable: context.watch<PooPeeProvider>().pooPees.isNotEmpty,
      // onEdit: () {
      //   showDialog(
      //       context: context, builder: (context) => const EditPooPeeDialog());
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
                "poo_pee.today".tr(),
                style: ThemeTextStyle.paragraph1(context,
                    color: AppTheme.colorShade.text),
              ),
              const SizedBox(
                width: AppTheme.spacing16,
              ),
              Text(
                "${PooPeeType.pee.label} $peeCount ${PooPeeType.poo.label} $pooCount",
                style: ThemeTextStyle.boldParagraph1(context,
                    color: AppTheme.colorShade.text),
              ),
            ]),
          ),
          const SizedBox(height: AppTheme.spacing20),
          Table(
            // columnWidths: const {
            //   0: FractionColumnWidth(0.25),
            //   1: FractionColumnWidth(0.25),
            //   2: FractionColumnWidth(0.25),
            // },
            children: [
              TableRow(children: [
                const SizedBox.shrink(),
                Center(
                    child: Padding(
                  padding: const EdgeInsets.only(bottom: AppTheme.spacing12),
                  child: Text(
                    "poo_pee.time".tr(),
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
                    "poo_pee.type_label".tr(),
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
        //   0: FractionColumnWidth(0.25),
        //   1: FractionColumnWidth(0.25),
        //   2: FractionColumnWidth(0.25),
        //   3: FractionColumnWidth(0.25),
        // },
        children: _generateDataRow(context),
      ),
    );
  }
}
