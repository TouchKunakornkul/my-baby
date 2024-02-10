import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_baby/configs/theme.dart';
import 'package:my_baby/icons/custom_icons_icons.dart';
import 'package:my_baby/providers/feeding_provider.dart';
import 'package:my_baby/providers/growth_provider.dart';
import 'package:my_baby/providers/menu_provider.dart';
import 'package:my_baby/providers/stock_provider.dart';
import 'package:my_baby/utils/double_utils.dart';
import 'package:provider/provider.dart';

const double ITEM_SIZE = 93;

class ListMenuBar extends StatelessWidget {
  final Function(Menu) onChangeMenu;
  final Menu? selectedMenu;
  const ListMenuBar({super.key, required this.onChangeMenu, this.selectedMenu});

  @override
  Widget build(BuildContext context) {
    final weight = context.watch<GrowthProvider>().weight;
    final averageAmountPerDay =
        context.watch<FeedingProvider>().averageAmountPerDay;
    final daysSaved = context.watch<StockProvider>().daysSaved;

    final widgets = [
      SummaryItem(
        icon: CustomIcons.growth,
        menu: Menu.Growth,
        selectedMenu: selectedMenu,
        onClick: onChangeMenu,
        text:
            "${weight != null ? formatDouble(weight) : '-'} ${"growth.kg".tr()}",
      ),
      SummaryItem(
        selectedMenu: selectedMenu,
        icon: CustomIcons.bottle,
        onClick: onChangeMenu,
        menu: Menu.Feeding,
        text: "${formatDouble(averageAmountPerDay)} ${"feeding.oz".tr()}",
      ),
      SummaryItem(
        selectedMenu: selectedMenu,
        icon: CustomIcons.milk,
        onClick: onChangeMenu,
        menu: Menu.MilkStock,
        text: "$daysSaved ${"stock.days".tr()}",
      ),
      // const SummaryItem(
      //   icon: CustomIcon.growth,
      //   text: "4.4kg",
      // ),
      // const SummaryItem(
      //   icon: CustomIcon.growth,
      //   text: "4.4kg",
      // ),
      // const SummaryItem(
      //   icon: CustomIcon.growth,
      //   text: "4.4kg",
      // ),
      // const SummaryItem(
      //   icon: CustomIcon.growth,
      //   text: "4.4kg",
      // ),
    ];
    return Container(
      height: ITEM_SIZE + (2 * AppTheme.spacing4),
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacing4),
      child: ListView.separated(
        // This next line does the trick.
        scrollDirection: Axis.horizontal,
        itemCount: widgets.length,
        itemBuilder: (context, index) {
          EdgeInsets? padding;
          if (index == widgets.length - 1) {
            padding = const EdgeInsets.only(right: AppTheme.spacing4);
          }
          if (index == 0) {
            padding = const EdgeInsets.only(left: AppTheme.spacing4);
          }
          return Container(padding: padding, child: widgets[index]);
        },
        separatorBuilder: (context, index) {
          return const SizedBox(
            width: AppTheme.spacing4,
          );
        },
      ),
    );
  }
}

class SummaryItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final Menu menu;
  final Menu? selectedMenu;
  final Function(Menu) onClick;
  const SummaryItem(
      {super.key,
      required this.icon,
      required this.text,
      required this.menu,
      required this.onClick,
      required this.selectedMenu});

  @override
  Widget build(BuildContext context) {
    final isSelected = menu == selectedMenu;
    return GestureDetector(
      onTap: () {
        onClick(menu);
      },
      child: Container(
        width: ITEM_SIZE,
        height: ITEM_SIZE,
        decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.colorShade.secondaryActive
                : AppTheme.colorShade.secondary,
            borderRadius: BorderRadius.circular(AppTheme.borderRadius8)),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 24,
                color: Colors.white,
              ),
              const SizedBox(
                height: AppTheme.spacing2,
              ),
              Text(
                text,
                style: ThemeTextStyle.boldParagraph2(
                  context,
                  color: Colors.white,
                ),
              ),
            ]),
      ),
    );
  }
}
