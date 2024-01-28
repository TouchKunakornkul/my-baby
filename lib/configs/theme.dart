import 'dart:math';

import 'package:flutter/material.dart';

class ColorShade {
  final Color dark;
  final Color main;
  final Color light;

  ColorShade({
    required this.dark,
    required this.main,
    required this.light,
  });
}

class Shade {
  final Color primary;
  final Color secondary;
  final Color tertiary;
  final Color text;
  final Color placeholder;
  final Color background;
  final Color background2;
  final Color error;
  final Color success;
  final Color border;
  final Color label;
  Shade({
    required this.primary,
    required this.secondary,
    required this.tertiary,
    required this.text,
    required this.placeholder,
    required this.background,
    required this.background2,
    required this.error,
    required this.success,
    required this.border,
    required this.label,
  });
}

class GreyScaleShade {
  final Color shade01;
  final Color shade02;
  final Color shade03;
  final Color shade04;
  final Color shade05;
  final Color shade06;
  final Color shade07;
  final Color shade08;

  GreyScaleShade({
    required this.shade01,
    required this.shade02,
    required this.shade03,
    required this.shade04,
    required this.shade05,
    required this.shade06,
    required this.shade07,
    required this.shade08,
  });
}

class AppTheme {
  static Shade colorShade = Shade(
    primary: const Color(0xff4E6AF6),
    secondary: const Color(0xffDFA2A2),
    tertiary: const Color(0xffFFE3E3),
    text: const Color(0xff372A2A),
    placeholder: const Color(0xffABA4A4),
    background: const Color(0xffEDEDED),
    background2: const Color(0xffF8F8F8),
    error: const Color(0xffFF4B4B),
    success: const Color(0xff69E39A),
    border: const Color(0xffC8C8C8),
    label: const Color(0xff4C4C4C),
  );

  static ColorShade primaryShade = ColorShade(
    dark: const Color(0xff17497C),
    main: const Color(0xff52A5CC),
    light: const Color(0xffCFE7F8),
  );

  static ColorShade secondaryShade = ColorShade(
    dark: const Color(0xff144E4E),
    main: const Color(0xff076B1D),
    light: const Color(0xff48BD2B),
  );

  static ColorShade yellowShade = ColorShade(
    dark: const Color(0xff9DA106),
    main: const Color.fromARGB(255, 170, 140, 33),
    light: const Color(0xffEDF08F),
  );

  static ColorShade redShade = ColorShade(
    dark: const Color(0xff9DA106),
    main: const Color(0xff52A5CC),
    light: const Color(0xffFFF1F1),
  );

  static ColorShade errorShade = ColorShade(
    dark: const Color(0xffF03E35),
    main: const Color(0xffFD7468),
    light: const Color(0xffFDF0EF),
  );

  static ColorShade warningShade = ColorShade(
    dark: const Color(0xFFA6841B),
    main: const Color(0xFFE7B902),
    light: const Color(0xFFFFF8DE),
  );

  static ColorShade successShade = ColorShade(
    dark: const Color(0xff2E9055),
    main: const Color(0xff59CB86),
    light: const Color(0xffF6FFF9),
  );

  static ColorShade blueShade = ColorShade(
    dark: const Color(0xff0F6F9E),
    main: const Color(0xff63B3D8),
    light: const Color(0xffDCF4FE),
  );

  static ColorShade greenShade = ColorShade(
    dark: const Color(0xff71971A),
    main: const Color(0xffB5D069),
    light: const Color(0xffF6FEDC),
  );

  static GreyScaleShade grayShade = GreyScaleShade(
    shade01: const Color(0xff000000),
    shade02: const Color(0xff565A5F),
    shade03: const Color(0xff73787D),
    shade04: const Color(0xffA69F9F),
    shade05: const Color(0xffD9D9D9),
    shade06: const Color(0xffF3F5FA),
    shade07: const Color(0xffFAFAFA),
    shade08: const Color(0xffffffff),
  );

  static MaterialColor primarySwatch =
      generateMaterialColor(colorShade.primary);

  static ThemeData themeData = ThemeData(
    dialogBackgroundColor: Colors.white,
    scaffoldBackgroundColor: grayShade.shade06,
    disabledColor: grayShade.shade05,
    dividerColor: grayShade.shade05,
    hintColor: grayShade.shade04,
    hoverColor: grayShade.shade02,
    canvasColor: Colors.white,
    colorScheme: ColorScheme.fromSwatch(primarySwatch: primarySwatch)
        .copyWith(
          secondary: primaryShade.light,
        )
        .copyWith(background: grayShade.shade06)
        .copyWith(error: errorShade.dark),
  );

  // Spacing
  static const double spacing64 = 64.0;
  static const double spacing56 = 56.0;
  static const double spacing48 = 48.0;
  static const double spacing44 = 44.0;
  static const double spacing40 = 40.0;
  static const double spacing36 = 36.0;
  static const double spacing32 = 32.0;
  static const double spacing28 = 28.0;
  static const double spacing24 = 24.0;
  static const double spacing20 = 20.0;
  static const double spacing16 = 16.0;
  static const double spacing14 = 14.0;
  static const double spacing12 = 12.0;
  static const double spacing10 = 10.0;
  static const double spacing8 = 8.0;
  static const double spacing6 = 6.0;
  static const double spacing4 = 4.0;
  static const double spacing2 = 2.0;

  static const double borderRadius4 = 4.0;
  static const double borderRadius8 = 8.0;
  static const double borderRadius12 = 12.0;
  static const double borderRadius20 = 20.0;
  static const double borderRadius50 = 50.0;

  // Font offset
  // Offset for increase font size from figma.
  static const double _fontOffset = 0;

  // Font size
  static const double fontSize48 = 48.0 + _fontOffset;
  static const double fontSize40 = 40.0 + _fontOffset;
  static const double fontSize32 = 32.0 + _fontOffset;
  static const double fontSize24 = 24.0 + _fontOffset;
  static const double fontSize20 = 20.0 + _fontOffset;
  static const double fontSize18 = 18.0 + _fontOffset;
  static const double fontSize16 = 16.0 + _fontOffset;
  static const double fontSize14 = 14.0 + _fontOffset;
  static const double fontSize12 = 12.0 + _fontOffset;
  static const double fontSize10 = 10.0 + _fontOffset;
  static const double fontSize9 = 9.0 + _fontOffset;

  static MaterialColor generateMaterialColor(Color color) {
    return MaterialColor(color.value, {
      50: tintColor(color, 0.5),
      100: tintColor(color, 0.4),
      200: tintColor(color, 0.3),
      300: tintColor(color, 0.2),
      400: tintColor(color, 0.1),
      500: tintColor(color, 0),
      600: tintColor(color, -0.1),
      700: tintColor(color, -0.2),
      800: tintColor(color, -0.3),
      900: tintColor(color, -0.4),
    });
  }

  static int tintValue(int value, double factor) =>
      max(0, min((value + ((255 - value) * factor)).round(), 255));

  static Color tintColor(Color color, double factor) => Color.fromRGBO(
      tintValue(color.red, factor),
      tintValue(color.green, factor),
      tintValue(color.blue, factor),
      1);

  static List<BoxShadow> softBoxShadow = [
    BoxShadow(
      color: const Color(0xff606170).withOpacity(0.08),
      spreadRadius: 0,
      blurRadius: 8,
      offset: const Offset(0, 4), // changes position of shadow
    ),
    BoxShadow(
      color: const Color(0xff28293D).withOpacity(0.04),
      spreadRadius: 0,
      blurRadius: 2,
      offset: const Offset(0, 0), // changes position of shadow
    ),
  ];
}

/*
 * ThemeTextStyle should convert style to any typeface, But the font using default from main themes(main_delegate.dart)
 *  * Example
 */
class ThemeTextStyle {
  static TextStyle _init(
    BuildContext context, {
    Color? color,
    double fontSize = AppTheme.fontSize14,
  }) {
    // Default
    double fontSize0 = fontSize;
    double height = 1.5;
    double letterSpacing = 0;

    TextStyle style;

    style = Theme.of(context).textTheme.bodyMedium!.copyWith(
          fontSize: fontSize0,
          height: height,
          letterSpacing: letterSpacing,
        );

    if (color != null) {
      style = style.copyWith(
        color: color,
      );
    }

    return style;
  }

  static TextStyle light(
    BuildContext context, {
    Color? color,
    double fontSize = AppTheme.fontSize14,
  }) {
    return _init(
      context,
      fontSize: fontSize,
      color: color,
    ).copyWith(
      fontWeight: FontWeight.w300,
    );
  }

  static TextStyle regular(
    BuildContext context, {
    Color? color,
    double fontSize = AppTheme.fontSize14,
  }) {
    return _init(
      context,
      fontSize: fontSize,
      color: color,
    ).copyWith(
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle medium(
    BuildContext context, {
    Color? color,
    double fontSize = AppTheme.fontSize14,
  }) {
    return _init(
      context,
      fontSize: fontSize,
      color: color,
    ).copyWith(
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle bold(
    BuildContext context, {
    Color? color,
    double fontSize = AppTheme.fontSize14,
  }) {
    return _init(
      context,
      fontSize: fontSize,
      color: color,
    ).copyWith(
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle italicRegular(
    BuildContext context, {
    Color? color,
    double fontSize = AppTheme.fontSize12,
  }) {
    return _init(
      context,
      fontSize: fontSize,
      color: color,
    ).copyWith(
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.italic,
    );
  }

  static TextStyle italicBold(
    BuildContext context, {
    Color? color,
    double fontSize = AppTheme.fontSize12,
  }) {
    return _init(
      context,
      fontSize: fontSize,
      color: color,
    ).copyWith(
      fontWeight: FontWeight.w700,
      fontStyle: FontStyle.italic,
    );
  }

  // Headline
  static TextStyle headline1(
    BuildContext context, {
    Color? color,
  }) =>
      bold(
        context,
        fontSize: AppTheme.fontSize32,
        color: color,
      );

  static TextStyle headline2(
    BuildContext context, {
    Color? color,
  }) =>
      bold(
        context,
        fontSize: AppTheme.fontSize24,
        color: color,
      );

  static TextStyle headline3(
    BuildContext context, {
    Color? color,
  }) =>
      bold(
        context,
        fontSize: AppTheme.fontSize20,
        color: color,
      );

  static TextStyle headline4(
    BuildContext context, {
    Color? color,
  }) =>
      bold(
        context,
        fontSize: AppTheme.fontSize18,
        color: color,
      );

  // Paragraph
  static TextStyle paragraph1(
    BuildContext context, {
    Color? color,
  }) =>
      medium(
        context,
        fontSize: AppTheme.fontSize16,
        color: color,
      );

  static TextStyle boldParagraph1(
    BuildContext context, {
    Color? color,
  }) =>
      bold(
        context,
        fontSize: AppTheme.fontSize16,
        color: color,
      );

  static TextStyle paragraph2(
    BuildContext context, {
    Color? color,
  }) =>
      medium(
        context,
        fontSize: AppTheme.fontSize14,
        color: color,
      );

  static TextStyle boldParagraph2(
    BuildContext context, {
    Color? color,
  }) =>
      bold(
        context,
        fontSize: AppTheme.fontSize14,
        color: color,
      );

  static TextStyle boldParagraph3(
    BuildContext context, {
    Color? color,
  }) =>
      bold(
        context,
        fontSize: AppTheme.fontSize12,
        color: color,
      );

  static TextStyle paragraph3(
    BuildContext context, {
    Color? color,
  }) =>
      regular(
        context,
        fontSize: AppTheme.fontSize12,
        color: color,
      );

  static TextStyle paragraph4(
    BuildContext context, {
    Color? color,
  }) =>
      regular(
        context,
        fontSize: AppTheme.fontSize10,
        color: color,
      );

  static TextStyle boldParagraph4(
    BuildContext context, {
    Color? color,
  }) =>
      bold(
        context,
        fontSize: AppTheme.fontSize10,
        color: color,
      );

  static TextStyle paragraph4reg(
    BuildContext context, {
    Color? color,
  }) =>
      regular(
        context,
        fontSize: AppTheme.fontSize10,
        color: color,
      );

  static TextStyle paragraph5(
    BuildContext context, {
    Color? color,
  }) =>
      regular(
        context,
        fontSize: AppTheme.fontSize9,
        color: color,
      );
}
