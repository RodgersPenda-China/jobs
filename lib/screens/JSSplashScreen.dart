import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:job_search/screens/JSSignUpScreen.dart';
import 'package:job_search/screens/select.dart';
import 'package:job_search/utils/JSColors.dart';
import 'package:job_search/utils/JSImage.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:job_search/main.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

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
      appBaseUrl: 'http://api.ioevisa.net/api/job/index.php?',
    ));
    Get.lazyPut(() => homeRepo(apiClient: Get.find()));
    Get.lazyPut(() => HomeController(HomeRepo: Get.find()));
    version();
  }
  version() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? light_dark = prefs.getBool('dark');
    if(light_dark  != null || light_dark == true){
      appStore.toggleDarkMode(value: true);
      setState(() {});
    }
    String version = '2.0.0';
    String url = "http://api.ioevisa.net/api/job/index.php?get_version=${version}";
    print(url);
    final response = await http.get(Uri.parse(url));
    var res = jsonDecode(response.body);
    if(res['error'] == 1 ){
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Oops...',
        text: 'Your Version Is Outdated',
        confirmBtnText: 'Download Latest',
        onConfirmBtnTap: (){
          launchUrl(Uri.parse('http://api.ioevisa.net/api/job/web.php'),mode: LaunchMode.externalApplication);
        return;
        }
      );
    } else {
      navigationPage();
    }
  }

  Future<Timer> init() async {
    setStatusBarColor(Colors.transparent);
   // await 3.seconds.delay;
    //finish(context);
    var _duration = Duration(seconds: 5);
    return Timer(_duration, navigationPage);
    //make a request to check current version of app


  }
  navigationPage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    bool? light_dark = prefs.getBool('dark');
    if(light_dark  != null || light_dark == true){
      appStore.toggleDarkMode(value: true);
      setState(() {});
    }
    if(token == null || token == '') {
      SelectScreen().launch(context);
    } else {
      JSSearchResultScreen().launch(context);
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
