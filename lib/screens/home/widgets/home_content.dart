import 'package:flutter/material.dart';
import 'package:my_baby/providers/menu_provider.dart';
import 'package:my_baby/screens/home/widgets/feeding/feeding_section.dart';
import 'package:my_baby/screens/home/widgets/growth/growth_section.dart';
import 'package:my_baby/screens/home/widgets/list_menu_bar.dart';
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
        color: Colors.white,
        child: Column(
          children: [
            ListMenuBar(
                selectedMenu: selectedMenu,
                onChangeMenu: (menu) => _onChangeMenu(context, menu)),
            Expanded(
                child: PageView(
              controller: context.watch<MenuProvider>().pageController,
              onPageChanged: (value) =>
                  _onChangeMenuFromPageView(context, Menu.values[value]),
              children: const [
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
