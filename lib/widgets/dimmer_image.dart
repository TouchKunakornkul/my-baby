import 'package:flutter/material.dart';
import 'package:my_baby/configs/theme.dart';

class DimmedImageOverlay extends StatefulWidget {
  final String imagePath;
  final String text;
  const DimmedImageOverlay(
      {super.key, required this.imagePath, required this.text});

  @override
  State<DimmedImageOverlay> createState() => _DimmedImageOverlayState();
}

class _DimmedImageOverlayState extends State<DimmedImageOverlay> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 2000));
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      backgroundColor: Colors.transparent,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(widget.imagePath),
            const SizedBox(
              height: AppTheme.spacing8,
            ),
            Text(
              widget.text,
              style: ThemeTextStyle.headline3(context, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
