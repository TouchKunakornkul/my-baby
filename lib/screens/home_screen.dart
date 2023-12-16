import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:my_baby/configs/database.dart';
import 'package:my_baby/configs/theme.dart';
import 'package:my_baby/icons/my_flutter_app_icons.dart';
import 'package:my_baby/providers/child_provider.dart';
import 'package:my_baby/providers/develop_provider.dart';
import 'package:my_baby/widgets/develop_section.dart';
import 'package:my_baby/widgets/edit_child_dialog.dart';
import 'package:my_baby/widgets/growth_line_chart.dart';
import 'package:my_baby/providers/growth_provider.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

const double IMAGE_HEIGHT = 770;

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
      // appBar: AppBar(
      //   // TRY THIS: Try changing the color here to a specific color (to
      //   // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
      //   // change color while the other colors stay the same.
      //   backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      //   // Here we take the value from the MyHomePage object that was created by
      //   // the App.build method, and use it to set our appbar title.
      //   title: const Text("test"),
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Stack(
                  children: [
                    FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image: 'https://picsum.photos/450/770',
                      height: IMAGE_HEIGHT,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      padding: const EdgeInsets.all(AppTheme.spacing16),
                      height: IMAGE_HEIGHT,
                      child: Column(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  child?.name ?? '-',
                                  style: ThemeTextStyle.headline1(context),
                                ),
                                Text(child?.birthDate.toString() ?? '-')
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
                              child: const Icon(CustomIcon.brain),
                            ),
                          ],
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
