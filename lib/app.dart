import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:locker/database/sql_manager.dart';
import 'package:locker/providers/add_good_provider.dart';
import 'package:locker/providers/classification_list_provider.dart';
import 'package:locker/providers/good_list_provider.dart';
import 'package:locker/providers/location_detail_provider.dart';
import 'package:locker/providers/location_provider.dart';
import 'package:locker/routes/routes.dart';
import 'package:locker/values/colors.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Routes.configureRouters(Router());
    SqlManager.init();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: ClassListProvider()),
        ChangeNotifierProvider.value(value: LocationProvider()),
        ChangeNotifierProvider.value(value: LocationDetailProvider()),
        ChangeNotifierProvider.value(value: GoodListProvider()),
        ChangeNotifierProvider.value(value: AddGoodProvider()),
      ],
      child: MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        supportedLocales: [
          const Locale('zh', 'CH'),
          const Locale('en', 'US'),
        ],
        locale: Locale('zh'),
        debugShowCheckedModeBanner: false,
        onGenerateRoute: Routes.router.generator,
        theme: ThemeData(
          primaryColor: main_color
        ),
      ),
    );
  }
}
