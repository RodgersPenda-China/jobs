import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:job_search/screens/JSSignUpScreen.dart';
import 'package:job_search/screens/select.dart';
import 'package:job_search/utils/JSColors.dart';
import 'package:job_search/utils/JSImage.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:job_search/main.dart';

import '../controller/api.dart';
import '../controller/home.dart';
import '../controller/repo.dart';
import 'JSProfileScreen.dart';
import 'JSSearchResultScreen.dart';

class JSSplashScreen extends StatefulWidget {
  const JSSplashScreen({Key? key}) : super(key: key);

  @override
  _JSSplashScreenState createState() => _JSSplashScreenState();
}

class _JSSplashScreenState extends State<JSSplashScreen> {
  @override
  void initState() {
    super.initState();
    Get.lazyPut(() => ApiClient(
      appBaseUrl: 'https://x.smartbuybuy.com/job/index.php?',
    ));
    Get.lazyPut(() => homeRepo(apiClient: Get.find()));
    Get.lazyPut(() => HomeController(HomeRepo: Get.find()));
    init();
  }

  Future<Timer> init() async {
    setStatusBarColor(Colors.transparent);
   // await 3.seconds.delay;
    //finish(context);
    var _duration = Duration(seconds: 5);
    return Timer(_duration, navigationPage);


  }
  navigationPage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if(token == null || token == '') {
      JSSearchResultScreen().launch(context);
    } else {
      JSProfileScreen().launch(context);
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(js_SplashImage, height: 130,fit: BoxFit.cover,color:appStore.isDarkModeOn?white: js_primaryColor),
          Image.asset(js_loader, height: 35.0, width: 35.0),
        ],
      ).center(),
    );
  }
}
