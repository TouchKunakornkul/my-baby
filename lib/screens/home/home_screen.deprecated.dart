import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_baby/configs/theme.dart';
import 'package:my_baby/icons/custom_icons_icons.dart';
import 'package:my_baby/providers/child_provider.dart';
import 'package:my_baby/providers/feeding_provider.dart';
import 'package:my_baby/providers/menu_provider.dart';
import 'package:my_baby/screens/home/widgets/growth/add_growth_dialog.dart';
import 'package:my_baby/screens/home/widgets/home_content.dart';
import 'package:my_baby/utils/date_utils.dart';
import 'package:my_baby/widgets/child_image.dart';
import 'package:my_baby/widgets/edit_child_dialog.dart';
import 'package:my_baby/providers/growth_provider.dart';
import 'package:my_baby/screens/home/widgets/list_menu_bar.deprecated.dart';
import 'package:provider/provider.dart';

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
    final child = context.read<ChildProvider>().child;
    if (child != null) {
      context.read<GrowthProvider>().setChild(child.id);
      context.read<FeedingProvider>().setChild(child.id);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                      width: MediaQuery.of(context).size.width,
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
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          child?.name ?? '-',
                                          overflow: TextOverflow.ellipsis,
                                          style:
                                              ThemeTextStyle.headline1(context)
                                                  .copyWith(fontSize: 40),
                                        ),
                                        if (child?.birthDate != null)
                                          Wrap(
                                            children: [
                                              Text(DateFormat('d MMM yyyy')
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
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(
                                        left: AppTheme.spacing12),
                                    child: InkWell(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return const EditChildDialog();
                                            });
                                      },
                                      child: Ink(
                                          child: const Icon(CustomIcons.edit)),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Expanded(child: SizedBox.shrink()),
                        // const ListMenuBar(),
                      ]),
                    )
                  ],
                ),
                const HomeContent()
              ],
            ),
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      floatingActionButton: context.watch<MenuProvider>().selectedMenu != null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 57,
                  height: 57,
                  child: FittedBox(
                    child: FloatingActionButton(
                      onPressed: () {
                        //...
                      },
                      backgroundColor: AppTheme.colorShade.label,
                      shape: const CircleBorder(),
                      child: const Icon(CustomIcons.noteAdd),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 68,
                  height: 68,
                  child: FittedBox(
                    child: FloatingActionButton(
                      backgroundColor: AppTheme.colorShade.primary,
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => const AddGrowthDialog());
                      },
                      shape: const CircleBorder(),
                      heroTag: null,
                      child: const Icon(
                        CustomIcons.add,
                        size: 36,
                      ),
                    ),
                  ),
                ),
              ],
            )
          : null,
    );
  }
}
