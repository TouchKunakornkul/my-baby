import 'package:flutter/material.dart';
import 'package:my_baby/configs/theme.dart';
import 'package:my_baby/icons/custom_icons_icons.dart';
import 'package:my_baby/providers/menu_provider.dart';

const double ITEM_SIZE = 52;

class ListMenuBar extends StatelessWidget {
  final Function(Menu) onChangeMenu;
  final Menu? selectedMenu;
  const ListMenuBar({super.key, required this.onChangeMenu, this.selectedMenu});

  @override
  Widget build(BuildContext context) {
    final widgets = [
      SummaryItem(
        icon: CustomIcons.baby,
        menu: Menu.MyBaby,
        selectedMenu: selectedMenu,
        onClick: onChangeMenu,
      ),
      SummaryItem(
        icon: CustomIcons.growth,
        menu: Menu.Growth,
        selectedMenu: selectedMenu,
        onClick: onChangeMenu,
      ),
      SummaryItem(
        selectedMenu: selectedMenu,
        icon: CustomIcons.bottle,
        onClick: onChangeMenu,
        menu: Menu.Feeding,
      ),
      SummaryItem(
        selectedMenu: selectedMenu,
        icon: CustomIcons.milk,
        onClick: onChangeMenu,
        menu: Menu.MilkStock,
      ),
      SummaryItem(
        selectedMenu: selectedMenu,
        icon: CustomIcons.poo,
        onClick: onChangeMenu,
        menu: Menu.PooPee,
      ),
    ];
    return Container(
      height: ITEM_SIZE + (2 * AppTheme.spacing4),
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacing4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ListView.separated(
            // This next line does the trick.
            scrollDirection: Axis.horizontal,
            itemCount: widgets.length,
            shrinkWrap: true,
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
                width: AppTheme.spacing14,
              );
            },
          ),
        ],
      ),
    );
  }
}

class SummaryItem extends StatelessWidget {
  final IconData icon;
  final Menu menu;
  final Menu? selectedMenu;
  final Function(Menu) onClick;
  const SummaryItem(
      {super.key,
      required this.icon,
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
          shape: BoxShape.circle,
          color: isSelected
              ? AppTheme.colorShade.secondaryActive
              : AppTheme.grayShade.shade05,
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 22,
                color: isSelected
                    ? Colors.white
                    : AppTheme.colorShade.secondaryActive,
              ),
            ]),
      ),
    );
  }
}
