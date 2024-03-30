import 'package:flutter/material.dart';
import 'package:my_baby/configs/theme.dart';
import 'package:my_baby/icons/custom_icons_icons.dart';
import 'package:my_baby/providers/menu_provider.dart';
import 'package:my_baby/screens/home/widgets/feeding/feeding_section.dart';
import 'package:my_baby/screens/home/widgets/growth/growth_section.dart';
import 'package:my_baby/screens/home/widgets/list_menu_bar.dart';
import 'package:my_baby/screens/home/widgets/my_baby/my_baby_section.dart';
import 'package:my_baby/screens/home/widgets/poo_pee/poo_pee_section.dart';
import 'package:my_baby/screens/home/widgets/stock/stock_section.dart';
import 'package:provider/provider.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  void _onChangeMenu(BuildContext context, Menu menu) {
    context.read<MenuProvider>().selectMenu(menu);
  }

  void _onChangeMenuFromPageView(BuildContext context, Menu menu) {
    context.read<MenuProvider>().selectMenuFromPageView(menu);
  }

  @override
  Widget build(BuildContext context) {
    final selectedMenu = context.watch<MenuProvider>().selectedMenu;
    if (selectedMenu == null) return const SizedBox.shrink();
    return Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
          color: Colors.white,
        ),
        child: Column(
          children: [
            InkWell(
              onTap: Navigator.of(context).pop,
              child: SizedBox(
                height: 30,
                child: Center(
                  child: Icon(
                    CustomIcons.chevronDown,
                    size: 10,
                    color: AppTheme.colorShade.placeholder,
                  ),
                ),
              ),
            ),
            ListMenuBar(
                selectedMenu: selectedMenu,
                onChangeMenu: (menu) => _onChangeMenu(context, menu)),
            Expanded(
                child: PageView(
              controller: context.watch<MenuProvider>().pageController,
              onPageChanged: (value) =>
                  _onChangeMenuFromPageView(context, Menu.values[value]),
              children: const [
                MyBabySection(),
                GrowthSection(),
                FeedingSection(),
                StockSection(),
                PooPeeSection(),
              ],
            ))
          ],
        ));
  }
}
