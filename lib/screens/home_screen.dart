import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:my_baby/configs/database.dart';
import 'package:my_baby/configs/theme.dart';
import 'package:my_baby/icons/my_flutter_app_icons.dart';
import 'package:my_baby/providers/child_provider.dart';
import 'package:my_baby/providers/develop_provider.dart';
import 'package:my_baby/utils/date_utils.dart';
import 'package:my_baby/widgets/child_image.dart';
import 'package:my_baby/widgets/develop_section.dart';
import 'package:my_baby/widgets/edit_child_dialog.dart';
import 'package:my_baby/widgets/growth_line_chart.dart';
import 'package:my_baby/providers/growth_provider.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

const double IMAGE_HEIGHT = 770;
const double LOGO_HEIGHT = 23;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    context.read<ChildProvider>().getChild();
    context.read<DevelopProvider>().listDevelops();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final growths = context.watch<GrowthProvider>().growths;
    final child = context.watch<ChildProvider>().child;
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: AppTheme.grayShade.shade08,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        toolbarHeight: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Stack(
                  children: [
                    ChildImage(
                      imageUrl: child?.imageUrl,
                      height: IMAGE_HEIGHT,
                    ),
                    SizedBox(
                      height: IMAGE_HEIGHT,
                      child: Column(children: [
                        Container(
                          padding: const EdgeInsets.only(
                              left: AppTheme.spacing16,
                              right: AppTheme.spacing16,
                              top: AppTheme.spacing44 - LOGO_HEIGHT,
                              bottom: AppTheme.spacing44),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.white,
                                Color.fromRGBO(217, 217, 217, 0.0),
                              ],
                              stops: [0.0, 1.0],
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                "assets/images/logo.png",
                                height: LOGO_HEIGHT,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        child?.name ?? '-',
                                        style:
                                            ThemeTextStyle.headline1(context),
                                      ),
                                      if (child?.birthDate != null)
                                        Wrap(
                                          children: [
                                            Text(DateFormat('dd MMM yyyy')
                                                .format(child!.birthDate)),
                                            const SizedBox(
                                              width: AppTheme.spacing4,
                                            ),
                                            Text(
                                                "(${getAgeString(child.birthDate)})"),
                                          ],
                                        )
                                    ],
                                  ),
                                  InkWell(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return const EditChildDialog();
                                          });
                                    },
                                    child: const Icon(CustomIcon.edit),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Expanded(child: SizedBox.shrink()),
                        const Row(),
                      ]),
                    )
                  ],
                ),
                // LineChart(
                //   LineChartData(
                //     minX: 1,
                //     minY: 1,
                //     lineBarsData: [
                //       LineChartBarData(
                //           spots: growths
                //               .asMap()
                //               .entries
                //               .map<FlSpot>((entry) =>
                //                   FlSpot(entry.key.toDouble(), entry.value.height))
                //               .toList(),
                //           isCurved: false,
                //           dotData: const FlDotData(
                //             show: false,
                //           ),
                //           color: Colors.red)
                //     ],
                //   ),
                // ),
                const DevelopSection(),
                const SizedBox(height: 300, child: GrowthLineChart()),
              ],
            ),
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
