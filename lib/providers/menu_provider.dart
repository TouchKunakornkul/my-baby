import 'package:flutter/material.dart';

enum Menu {
  Growth,
  Feeding,
  MilkStock,
  PooPee,
}

class MenuProvider extends ChangeNotifier {
  Menu? selectedMenu;
  PageController pageController = PageController();

  Future<void> selectMenuFromPageView(Menu? menu) async {
    selectedMenu = menu;
    notifyListeners();
  }

  Future<void> selectMenu(Menu? menu) async {
    if (menu != null) {
      if (!pageController.hasClients) {
        selectedMenu = menu;
        pageController = PageController(initialPage: menu.index);
      } else {
        pageController.animateToPage(menu.index,
            duration: const Duration(milliseconds: 200),
            curve: Curves.fastOutSlowIn);
      }
    }
    notifyListeners();
  }
}
