import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_baby/configs/router_config.dart';
import 'package:my_baby/configs/theme.dart';
import 'package:my_baby/providers/child_provider.dart';
import 'package:my_baby/providers/develop_provider.dart';
import 'package:my_baby/providers/growth_provider.dart';
import 'package:my_baby/providers/menu_provider.dart';
import 'package:my_baby/service/locator.dart';
import 'package:provider/provider.dart';

void main() async {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider<ChildProvider>(create: (_) => ChildProvider()),
        ChangeNotifierProvider<GrowthProvider>(create: (_) => GrowthProvider()),
        ChangeNotifierProvider<MenuProvider>(create: (_) => MenuProvider()),
        ChangeNotifierProvider<DevelopProvider>(
            create: (_) => DevelopProvider()),
      ],
      child: EasyLocalization(
          // useOnlyLangCode: true,
          supportedLocales: const [
            // Locale('en', 'GB'),
            Locale('th'),
          ],
          path: 'assets/translations',
          fallbackLocale: const Locale('th'),
          child: const MyApp())));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = ThemeData(
      canvasColor: Colors.transparent,
      primaryColor: Colors.white,
      pageTransitionsTheme: const PageTransitionsTheme(builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder()
      }),
      primarySwatch: AppTheme.primarySwatch,
      unselectedWidgetColor: AppTheme.grayShade.shade05,
      useMaterial3: true,
    ).copyWith(
      scaffoldBackgroundColor: AppTheme.themeData.scaffoldBackgroundColor,
      dialogBackgroundColor: AppTheme.themeData.dialogBackgroundColor,
      disabledColor: AppTheme.themeData.disabledColor,
      dividerColor: AppTheme.themeData.dividerColor,
      hintColor: AppTheme.themeData.hintColor,
      hoverColor: AppTheme.themeData.hoverColor,
      canvasColor: AppTheme.themeData.canvasColor,
      textSelectionTheme: TextSelectionTheme.of(context).copyWith(
        cursorColor: AppTheme.primarySwatch[500],
      ),
      colorScheme: AppTheme.themeData.colorScheme
          .copyWith(background: AppTheme.themeData.colorScheme.background)
          .copyWith(error: AppTheme.themeData.colorScheme.error),
    );

    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: themeData,
      routerConfig: CustomRouter,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }
}
