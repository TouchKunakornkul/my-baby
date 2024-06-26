import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_baby/configs/database.dart';
import 'package:my_baby/configs/theme.dart';
import 'package:my_baby/icons/custom_icons_icons.dart';
import 'package:my_baby/providers/stock_provider.dart';
import 'package:my_baby/screens/home/widgets/growth/growth_infomation.dart';
import 'package:my_baby/screens/home/widgets/stock/add_stock_dialog.dart';
import 'package:my_baby/screens/home/widgets/stock/edit_stock_dialog.dart';
import 'package:my_baby/utils/double_utils.dart';
import 'package:my_baby/widgets/base_information_bottom_sheet.dart';
import 'package:my_baby/widgets/base_section.dart';
import 'package:provider/provider.dart';

class StockSection extends StatelessWidget {
  const StockSection({super.key});

  void _onEdit(BuildContext context, Stock stock) {
    showDialog(
        context: context, builder: (context) => EditStockDialog(stock: stock));
  }

  List<TableRow> _generateDataRow(BuildContext context) {
    final stocksByDay = context.watch<StockProvider>().stocksByDay;
    final List<TableRow> widgets = [];
    for (var element in stocksByDay.entries) {
      for (var i = 0; i < element.value.length; i++) {
        double sumOuncesPerDay = 0.0;
        for (var i = 0; i < element.value.length; i++) {
          sumOuncesPerDay += element.value[i].amount;
        }
        final stock = element.value[i];
        widgets.add(TableRow(children: [
          ...(i == 0
              ? [
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.middle,
                    child: Center(
                      child: Text(
                        DateFormat('d MMM').format(stock.createdAt),
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
              onTap: () => _onEdit(context, stock),
              child: Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: AppTheme.spacing2),
                  child: Text(
                    DateFormat('HH:mm').format(stock.createdAt),
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
              onTap: () => _onEdit(context, stock),
              child: Center(
                child: Text(
                  formatDouble(stock.amount),
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

  void _onAddStockNote(BuildContext context, String note) {
    context.read<StockProvider>().addStockNote(note);
  }

  void _onEditStockNote(BuildContext context, Note note) {
    context.read<StockProvider>().updateStockNote(note);
  }

  void _onDeleteStockNote(BuildContext context, Note note) {
    context.read<StockProvider>().deleteStockNote(note);
  }

  @override
  Widget build(BuildContext context) {
    return BaseSection(
      notes: context.watch<StockProvider>().notes,
      icon: CustomIcons.growth,
      title: "stock.title".tr(),
      subtitle:
          // Text(
          //   "stock.subtitle".tr(),
          //   style:
          //       ThemeTextStyle.paragraph1(context, color: AppTheme.colorShade.text),
          // ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          "stock.total_stock".tr(),
          style: ThemeTextStyle.paragraph3(context,
              color: AppTheme.colorShade.text),
        ),
        const SizedBox(
          width: AppTheme.spacing8,
        ),
        Text(
          "${formatDouble(context.watch<StockProvider>().availableStock)} ${"stock.oz".tr()}",
          style: ThemeTextStyle.headline2(context,
              color: AppTheme.colorShade.green),
        ),
      ]),
      onAddNote: (note) => _onAddStockNote(context, note),
      onEditNote: (note) => _onEditStockNote(context, note),
      onDeleteNote: (note) => _onDeleteStockNote(context, note),
      onClickBook: () {
        BaseInformationBottomSheet.show(context, const GrowthInformation());
      },
      onAdd: () {
        showDialog(
            context: context, builder: (context) => const AddStockDialog());
      },
      editable: context.watch<StockProvider>().showedStocks.isNotEmpty,
      // onEdit: () {
      //   showDialog(
      //       context: context, builder: (context) => const EditStockDialog());
      // },
      header: Column(
        children: [
          Table(
            columnWidths: const {
              0: FractionColumnWidth(0.25),
              1: FractionColumnWidth(0.25),
              2: FractionColumnWidth(0.25),
              3: FractionColumnWidth(0.25),
            },
            children: [
              TableRow(children: [
                const SizedBox.shrink(),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: AppTheme.spacing12),
                    child: Text(
                      "stock.daily".tr(),
                      style: ThemeTextStyle.boldParagraph3(
                        context,
                        color: AppTheme.colorShade.placeholder,
                      ),
                    ),
                  ),
                ),
                Center(
                    child: Padding(
                  padding: const EdgeInsets.only(bottom: AppTheme.spacing12),
                  child: Text(
                    "stock.time".tr(),
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
        columnWidths: const {
          0: FractionColumnWidth(0.25),
          1: FractionColumnWidth(0.25),
          2: FractionColumnWidth(0.25),
          3: FractionColumnWidth(0.25),
        },
        children: _generateDataRow(context),
      ),
    );
  }
}
