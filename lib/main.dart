import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_baby/configs/router_config.dart';
import 'package:my_baby/configs/theme.dart';
import 'package:my_baby/constants/share_preferences_constants.dart';
import 'package:my_baby/providers/app_provider.dart';
import 'package:my_baby/providers/child_provider.dart';
import 'package:my_baby/providers/develop_provider.dart';
import 'package:my_baby/providers/feeding_provider.dart';
import 'package:my_baby/providers/growth_provider.dart';
import 'package:my_baby/providers/menu_provider.dart';
import 'package:my_baby/providers/poo_pee_provider.dart';
import 'package:my_baby/providers/stock_provider.dart';
import 'package:my_baby/service/locator.dart';
import 'package:my_baby/service/notification_service.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('/assets/google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  final prefs = await SharedPreferences.getInstance();
  final notificationEnabled =
      prefs.getBool(SharedPreferencesConstants.notificationEnabled) ?? true;
  final feedingHourDuration =
      prefs.getInt(SharedPreferencesConstants.feedingHourDuration);
  final feedingStartTime =
      prefs.getString(SharedPreferencesConstants.feedingStartTime);
  final NotificationService notificationService =
      locator<NotificationService>();
  notificationService.initialize();
  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider<AppProvider>(
            create: (_) => AppProvider(
                notificationEnabled: notificationEnabled,
                packageInfo: packageInfo)),
        ChangeNotifierProvider<ChildProvider>(create: (_) => ChildProvider()),
        ChangeNotifierProvider<GrowthProvider>(create: (_) => GrowthProvider()),
        ChangeNotifierProvider<MenuProvider>(create: (_) => MenuProvider()),
        ChangeNotifierProvider<StockProvider>(create: (_) => StockProvider()),
        ChangeNotifierProxyProvider<StockProvider, FeedingProvider>(
            create: (context) => FeedingProvider(
                  hourDuration: feedingHourDuration,
                  startTime: feedingStartTime != null
                      ? DateTime.tryParse(feedingStartTime)
                      : null,
                ),
            update: (context, stockProvider, feedingProvider) =>
                feedingProvider!..update(stockProvider)),
        ChangeNotifierProvider<PooPeeProvider>(create: (_) => PooPeeProvider()),
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
