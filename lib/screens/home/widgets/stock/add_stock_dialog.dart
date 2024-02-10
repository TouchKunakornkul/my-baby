import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_baby/configs/theme.dart';
import 'package:my_baby/providers/stock_provider.dart';
import 'package:my_baby/widgets/base_date_picker.dart';
import 'package:my_baby/widgets/base_dialog.dart';
import 'package:my_baby/widgets/base_text_input.dart';
import 'package:my_baby/widgets/base_time_picker.dart';
import 'package:provider/provider.dart';

class AddStockDialog extends StatefulWidget {
  const AddStockDialog({super.key});

  @override
  State<AddStockDialog> createState() => _AddStockDialogState();
}

class _AddStockDialogState extends State<AddStockDialog> {
  final TextEditingController _amountController = TextEditingController();
  DateTime _stockAt = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _addStock() async {
    final amount = double.tryParse(_amountController.text);
    if (amount != null) {
      await context
          .read<StockProvider>()
          .addStock(createdAt: _stockAt, amount: amount);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      title: 'stock.add_title'.tr(),
      content: Column(children: [
        const SizedBox(
          height: AppTheme.spacing20,
        ),
        BaseDatePicker(
          label: "stock.date".tr(),
          value: _stockAt,
          onChange: (date) {
            setState(() {
              _stockAt = date;
            });
          },
        ),
        BaseTimePicker(
          label: "stock.time".tr(),
          initialTime: _stockAt,
          onChange: (time) {
            setState(() {
              _stockAt = time;
            });
          },
        ),
        BaseTextInput(
          label: "stock.amount".tr(),
          type: InputType.number,
          controller: _amountController,
          hintText: "feeding.ounce".tr(),
          validator: (value) {
            if (value == null || value == "") {
              return "error.form_required".tr();
            }
            return null;
          },
        ),
      ]),
      okText: "common.+add".tr(),
      onOk: _addStock,
    );
  }
}
