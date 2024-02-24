import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_baby/configs/theme.dart';
import 'package:my_baby/providers/feeding_provider.dart';
import 'package:my_baby/providers/stock_provider.dart';
import 'package:my_baby/utils/double_utils.dart';
import 'package:my_baby/widgets/base_bottom_sheet.dart';
import 'package:my_baby/widgets/base_dialog.dart';
import 'package:my_baby/widgets/base_select_input.dart';
import 'package:my_baby/widgets/base_text_input.dart';
import 'package:provider/provider.dart';

class EditStockDialog extends StatefulWidget {
  const EditStockDialog({
    super.key,
  });

  @override
  State<EditStockDialog> createState() => _EditStockDialogState();
}

class _EditStockDialogState extends State<EditStockDialog> {
  final TextEditingController _amountController = TextEditingController();
  late String _selectedItem;

  @override
  void initState() {
    final stocks = context.read<StockProvider>().showedStocks;
    _selectedItem = stocks[0].id.toString();

    _amountController.text = formatDouble(stocks[0].amount);
    super.initState();
  }

  Future<void> _editStock() async {
    final amount = double.tryParse(_amountController.text);
    if (amount != null) {
      final stocks = context.read<StockProvider>().showedStocks;
      final updatedStock =
          stocks.firstWhere((f) => f.id.toString() == _selectedItem);
      await context
          .read<StockProvider>()
          .updateStock(updatedStock.copyWith(amount: amount));
    }
  }

  _onChangeDate(String value) {
    final stocks = context.read<StockProvider>().showedStocks;
    final selectedStock =
        stocks.firstWhere((f) => f.id.toString() == _selectedItem);
    setState(() {
      _amountController.text = formatDouble(selectedStock.amount);
      _selectedItem = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dateList = context
        .watch<StockProvider>()
        .showedStocks
        .map((e) => SelectItem(
            label: DateFormat('d MMM yyyy HH:mm').format(e.createdAt),
            value: e.id.toString()))
        .toList();
    return BaseDialog(
      title: 'stock.edit_title'.tr(),
      content: Column(children: [
        const SizedBox(
          height: AppTheme.spacing20,
        ),
        BaseSelectInput(
          hint: "stock.date".tr(),
          items: dateList,
          initialValue: _selectedItem,
          onChanged: _onChangeDate,
          label: "stock.feed_time".tr(),
        ),
        const SizedBox(
          height: AppTheme.spacing36,
        ),
        BaseTextInput(
          label: "stock.amount".tr(),
          controller: _amountController,
          type: InputType.number,
          hintText: "stock.ounce".tr(),
          validator: (value) {
            if (value == null || value == "") {
              return "error.form_required".tr();
            }
            return null;
          },
        ),
      ]),
      okText: "common.save".tr(),
      onOk: _editStock,
    );
  }
}
