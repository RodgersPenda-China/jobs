import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:job_search/screens/JSSplashScreen.dart';
import 'package:job_search/store/AppStore.dart';
import 'package:job_search/utils/AppTheme.dart';
import 'package:nb_utils/nb_utils.dart';
AppStore appStore = AppStore();
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(appStore.isDarkModeOn);
    return Observer(
      builder: (_) => MaterialApp(
        scrollBehavior: SBehavior(),
        navigatorKey: navigatorKey,
        title: 'Job Search',
        debugShowCheckedModeBanner: false,
        theme: AppThemeData.lightTheme,
        darkTheme: AppThemeData.darkTheme,
        themeMode: appStore.isDarkModeOn ? ThemeMode.dark : ThemeMode.light,
        home: JSSplashScreen(),
        builder: EasyLoading.init(),
        // supportedLocales: LanguageDataModel.languageLocales(),
/*        localizationsDelegates: [
          AppLocalizations(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        localeResolutionCallback: (locale, supportedLocales) => locale,
        locale: Locale(appStore.selectedLanguage.validate(value: AppConstant.defaultLanguage)),*/
      ),
    );

  }
}

