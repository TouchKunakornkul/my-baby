import 'package:flutter/material.dart';
import 'package:my_baby/configs/theme.dart';

class BaseInformationBottomSheet {
  static void show(
    BuildContext parentContext,
    Widget content,
  ) {
    showModalBottomSheet(
      context: parentContext,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppTheme.borderRadius8),
          topRight: Radius.circular(AppTheme.borderRadius8),
        ),
      ),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SafeArea(
            child: AnimatedPadding(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.height -
                (kBottomNavigationBarHeight + kToolbarHeight) -
                55,
            child: content,
          ),
        ));
      },
    );
  }
}
