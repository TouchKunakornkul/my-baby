import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_baby/configs/theme.dart';
import 'package:my_baby/widgets/base_button.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(AppTheme.spacing24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/logo-text.png",
                height: 50,
              ),
              const SizedBox(
                height: AppTheme.spacing14,
              ),
              Text(
                "onboarding.title".tr(),
                style: ThemeTextStyle.headline1(context,
                    color: const Color(0xFFEA7509)),
              ),
              const SizedBox(
                height: AppTheme.spacing16,
              ),
              Image.asset(
                "assets/images/onboarding.png",
                width: MediaQuery.of(context).size.width -
                    (AppTheme.spacing24 * 2),
              ),
              const SizedBox(height: AppTheme.spacing20),
              BaseButton(
                "common.next".tr(),
                onPressed: () {
                  context.go('/support');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
