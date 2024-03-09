import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_baby/configs/theme.dart';
import 'package:my_baby/constants/share_preferences_constants.dart';
import 'package:my_baby/widgets/base_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Person {
  final String name;
  final String position;
  final String image;
  const Person({
    required this.name,
    required this.position,
    required this.image,
  });
}

const List<Person> persons = [
  Person(
    name: "Doctor Somchai Soe",
    position: "Information Prover",
    image: "",
  ),
  Person(
    name: "Warapun Kraukrey",
    position: "Co founder Nurse Consult",
    image: "",
  ),
  Person(
    name: "Doctor Apirak Sake",
    position: "Information Prover",
    image: "",
  ),
];

class _Item extends StatelessWidget {
  final String title;
  final String subtitle;
  final String image;
  const _Item({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.image,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipOval(
          child: image.isNotEmpty
              ? Image.asset(
                  image,
                  width: 89.0,
                  height: 89.0,
                )
              : Container(
                  width: 89.0,
                  height: 89.0,
                  color: const Color(0xFFD9D9D9),
                ),
        ),
        const SizedBox(
          width: AppTheme.spacing16,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: ThemeTextStyle.boldParagraph1(
                context,
                color: AppTheme.colorShade.text,
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              subtitle,
              style: ThemeTextStyle.paragraph1(
                context,
                color: AppTheme.colorShade.text,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class SupportScreen extends StatelessWidget {
  const SupportScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Title section
            Positioned(
              right: AppTheme.spacing24,
              top: AppTheme.spacing24,
              child: Transform.rotate(
                angle: 15 * pi / 180,
                child: Image.asset(
                  // Replace with your logo image asset
                  'assets/images/logo.png',
                  width: 108,
                  color: const Color(0xFFC7E1FF),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(AppTheme.spacing24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.all(20.0), // Adjust padding as needed
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "support.title".tr(),
                              style: ThemeTextStyle.headline1(
                                context,
                                color: AppTheme.colorShade.text,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppTheme.spacing44),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 3,
                          itemBuilder: (context, i) => _Item(
                            title: persons[i].name,
                            subtitle: persons[i].position,
                            image: persons[i].image,
                          ),
                          separatorBuilder: (context, index) => const SizedBox(
                            height: AppTheme.spacing28,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 145,
                  ),
                  BaseButton(
                    "common.next".tr(),
                    onPressed: () {
                      WidgetsBinding.instance.addPostFrameCallback((_) async {
                        final pref = await SharedPreferences.getInstance();
                        pref.setBool(
                            SharedPreferencesConstants.onboarded, true);
                      });
                      context.go('/home');
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
