import 'package:flutter/material.dart';
import 'package:my_baby/configs/theme.dart';

enum ButtonType {
  primary,
  secondary,
  error,
}

enum ButtonBorder {
  square,
  circular,
}

enum ButtonSize {
  large,
  medium,
  small,
}

enum ButtonColor {
  primary,
  red,
  green,
  blue,
}

class BaseButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final ButtonColor? color;
  final ButtonType type;
  final ButtonSize size;
  final bool disabled;
  final double? borderRadius;
  final double horizontalPadding;
  final double? height;
  final double? width;
  final double? maxWidth;
  final String? suffixIcon;
  final IconData? prefixIcon;
  final String? imageAsset;
  final FontWeight? fontWeight;
  final ButtonBorder buttonBorder;
  final bool hasIconSpace;

  const BaseButton(
    this.text, {
    Key? key,
    required this.onPressed,
    this.type = ButtonType.primary,
    this.size = ButtonSize.medium,
    this.width,
    this.maxWidth,
    this.height,
    this.disabled = false,
    this.prefixIcon,
    this.suffixIcon,
    this.imageAsset,
    this.borderRadius,
    this.horizontalPadding = AppTheme.spacing16,
    this.buttonBorder = ButtonBorder.square,
    this.color,
    this.fontWeight,
    this.hasIconSpace = true,
  }) : super(key: key);

  ColorShade get _colorShade {
    switch (color) {
      case ButtonColor.green:
        return AppTheme.successShade;
      case ButtonColor.red:
        return AppTheme.errorShade;
      case ButtonColor.blue:
        return AppTheme.blueShade;
      case ButtonColor.primary:
      default:
        return AppTheme.primaryShade;
    }
  }

  Color get _borderColor {
    if (disabled) {
      return AppTheme.grayShade.shade05;
    } else {
      if (type == ButtonType.primary) {
        return _colorShade.light;
      }
      return _colorShade.main;
    }
  }

  double get _height {
    if (height != null) {
      return height!;
    }
    switch (size) {
      case ButtonSize.large:
        return 48;
      case ButtonSize.small:
        return 32;
      case ButtonSize.medium:
      default:
        return 51;
    }
  }

  Color get _bgColor {
    if (type == ButtonType.secondary) {
      return Colors.transparent;
    }
    if (type == ButtonType.error) {
      return AppTheme.colorShade.error;
    }
    if (disabled) return AppTheme.colorShade.placeholder;
    return AppTheme.colorShade.primary;
  }

  Color get _textColor {
    if (type == ButtonType.secondary) {
      if (disabled) return AppTheme.grayShade.shade05;
      return _colorShade.main;
    }
    if (disabled) return AppTheme.grayShade.shade04;
    return Colors.white;
  }

  TextStyle _textStyle(BuildContext context) {
    var style = ThemeTextStyle.boldParagraph1(
      context,
      color: _textColor,
    );
    if (fontWeight != null) {
      style = style.copyWith(fontWeight: fontWeight);
    }
    return style;
  }

  double get _borderRadius {
    if (borderRadius != null) return borderRadius!;
    return buttonBorder == ButtonBorder.square
        ? AppTheme.borderRadius12
        : AppTheme.borderRadius50;
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsets>(
              EdgeInsets.symmetric(horizontal: horizontalPadding),
            ),
            maximumSize: maxWidth != null
                ? MaterialStateProperty.all(Size(maxWidth ?? 0.0, _height))
                : null,
            backgroundColor: MaterialStateProperty.all<Color>(
              _bgColor,
            ),
            elevation: MaterialStateProperty.all<double>(0),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(_borderRadius),
                side: BorderSide(
                  color: _borderColor,
                  width: type == ButtonType.secondary ? 1 : 0,
                ),
              ),
            ),
            minimumSize:
                MaterialStateProperty.all<Size>(Size(width ?? 0.0, _height))),
        onPressed: disabled ? null : onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if (prefixIcon != null)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Icon(
                  prefixIcon,
                  color: _textColor,
                  size: 18,
                ),
              ),
            if (prefixIcon != null && hasIconSpace)
              const SizedBox(
                width: AppTheme.spacing8,
              ),
            if (imageAsset != null)
              Image.asset(
                imageAsset!,
                height: 18,
                width: 18,
                color: _textColor,
              ),
            Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              textAlign: TextAlign.center,
              style: _textStyle(context),
            ),
          ],
        ));
  }
}
