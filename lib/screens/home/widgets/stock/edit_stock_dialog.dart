import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_baby/configs/database.dart';
import 'package:my_baby/configs/theme.dart';
import 'package:my_baby/providers/stock_provider.dart';
import 'package:my_baby/utils/double_utils.dart';
import 'package:my_baby/widgets/base_date_picker.dart';
import 'package:my_baby/widgets/base_dialog.dart';
import 'package:my_baby/widgets/base_text_input.dart';
import 'package:my_baby/widgets/base_time_picker.dart';
import 'package:provider/provider.dart';

class EditStockDialog extends StatefulWidget {
  final Stock stock;
  const EditStockDialog({
    super.key,
    required this.stock,
  });

  @override
  State<EditStockDialog> createState() => _EditStockDialogState();
}

class _EditStockDialogState extends State<EditStockDialog> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  DateTime _stockAt = DateTime.now();

  @override
  void initState() {
    final stock = widget.stock;
    _dateController.text =
        DateFormat('d MMM yyyy HH:mm').format(stock.createdAt);

    _amountController.text = formatDouble(stock.amount);
    _stockAt = stock.createdAt;
    super.initState();
  }

  Future<void> _editStock() async {
    final amount = double.tryParse(_amountController.text);
    if (amount != null) {
      await context.read<StockProvider>().updateStock(
          widget.stock.copyWith(amount: amount, createdAt: _stockAt));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      title: 'stock.edit_title'.tr(),
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
