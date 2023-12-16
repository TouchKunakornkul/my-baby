import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_baby/configs/theme.dart';

enum InputType {
  normal,
  password,
  search,
  number,
  multiline,
}

class BaseTextInput extends StatefulWidget {
  final String? label;
  final FormFieldValidator<String>? validator;
  final String? initialValue;
  final String? hintText;
  final Icon? prefixIcon;
  final InputType type;
  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final Function(String)? onChanged;
  final int? maxLines;
  final int? minLines;
  final bool? enabled;
  final bool disabledHelperText;
  final FocusNode? focusNode;
  final ScrollController? scrollController;
  final bool showBorder;
  final List<TextInputFormatter>? inputFormatters;
  const BaseTextInput(
      {Key? key,
      this.type = InputType.normal,
      this.label,
      this.validator,
      this.initialValue,
      this.hintText,
      this.prefixIcon,
      this.controller,
      this.textInputAction,
      this.onChanged,
      this.maxLines,
      this.minLines,
      this.enabled,
      this.focusNode,
      this.disabledHelperText = false,
      this.scrollController,
      this.inputFormatters,
      this.showBorder = true})
      : super(key: key);

  @override
  State<BaseTextInput> createState() => _BaseTextInputState();
}

class _BaseTextInputState extends State<BaseTextInput> {
  bool _obscureText = true;

  void toggleObscure() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Widget? _getSuffixIcon() {
    switch (widget.type) {
      case InputType.password:
      case InputType.search:
      case InputType.normal:
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Text(
            widget.label!,
            style: ThemeTextStyle.paragraph2(
              context,
              color: AppTheme.grayShade.shade03,
            ),
          ),
        const SizedBox(
          height: 2,
        ),
        TextFormField(
          inputFormatters: widget.inputFormatters,
          scrollController: widget.scrollController,
          enabled: widget.enabled,
          maxLines: widget.type == InputType.password ? 1 : widget.maxLines,
          minLines: widget.minLines,
          validator: widget.validator,
          initialValue: widget.initialValue,
          controller: widget.controller,
          focusNode: widget.focusNode,
          keyboardType: widget.type == InputType.number
              ? TextInputType.number
              : (widget.type == InputType.multiline
                  ? TextInputType.multiline
                  : null),
          textInputAction: widget.textInputAction,
          onChanged: widget.onChanged,
          obscureText: widget.type == InputType.password ? _obscureText : false,
          style: ThemeTextStyle.paragraph2(context,
              color: widget.enabled != null && widget.enabled == false
                  ? AppTheme.grayShade.shade03
                  : AppTheme.grayShade.shade01),
          decoration: InputDecoration(
            isDense: true,
            helperText: widget.disabledHelperText ? null : ' ',
            prefixIcon: widget.prefixIcon != null
                ? Padding(
                    padding: const EdgeInsets.all(AppTheme.spacing10),
                    child: widget.prefixIcon,
                  )
                : null,
            contentPadding: widget.prefixIcon != null
                ? const EdgeInsets.all(0)
                : widget.showBorder
                    ? const EdgeInsets.symmetric(
                        vertical: AppTheme.spacing12,
                        horizontal: AppTheme.spacing12)
                    : const EdgeInsets.all(0),
            hintText: widget.hintText,
            filled: true,
            errorStyle: ThemeTextStyle.paragraph3(context,
                color: AppTheme.errorShade.main),
            fillColor: widget.enabled != null && widget.enabled == false
                ? AppTheme.grayShade.shade07
                : Colors.transparent,
            enabledBorder: widget.showBorder
                ? OutlineInputBorder(
                    borderSide:
                        BorderSide(color: AppTheme.grayShade.shade05, width: 1))
                : null,
            border: widget.showBorder
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppTheme.borderRadius4),
                  )
                : InputBorder.none,
            suffixIcon: _getSuffixIcon(),
          ),
        ),
      ],
    );
  }
}
