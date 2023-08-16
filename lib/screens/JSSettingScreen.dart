import 'package:flutter/material.dart';
import 'package:job_search/components/JSDrawerScreen.dart';
import 'package:job_search/components/JSSettingComponent.dart';
import 'package:job_search/main.dart';
import 'package:job_search/screens/password.dart';
import 'package:job_search/utils/JSWidget.dart';
import 'package:nb_utils/nb_utils.dart';

class JSSettingScreen extends StatefulWidget {
  const JSSettingScreen({Key? key}) : super(key: key);

  @override
  _JSSettingScreenState createState() => _JSSettingScreenState();
}

class _JSSettingScreenState extends State<JSSettingScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    init();
  }
  String email = 'Please Login';
  void init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if(token != null && token != ''){
      setState(() {
        email = prefs.getString('email')!;

      });
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: JSDrawerScreen(),
      appBar: jsAppBar(context, notifications: false, message: false, bottomSheet: false, backWidget: true, homeAction: false, callBack: () {
        setState(() {});
        scaffoldKey.currentState!.openDrawer();
      }),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          16.height,
          Text("Settings", style: boldTextStyle(size: 28)).paddingOnly(left: 16),
          8.height,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(height: 0),
              8.height,
              email == 'Please Login'?SizedBox():Column(
               children: [
                 GestureDetector(
                   onTap: (){
                     PasswordScreen().launch(context);
                   },
                   child:  SettingItemWidget(
                     title: "Password Settings",
                     titleTextStyle: boldTextStyle(size: 18),
                     subTitle: "Reset Your Password",
                     leading: Icon(Icons.lock_sharp),
                     trailing: Icon(Icons.arrow_forward_ios, size: 18),
                   ),
                 ),

               ],
             ),

              16.height,
              ListTile(
                minLeadingWidth: 0,
                title: Text("Dark Mode", style: boldTextStyle()),
                leading: Icon(Icons.dark_mode, size: 26, color: context.iconColor),
                trailing: Switch(
                  value: appStore.isDarkModeOn,
                  onChanged: (bool value)  async {
                    appStore.toggleDarkMode(value: value);
                    setState(() {});
                    final SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.setBool('dark', value);
                  },
                ),
                onTap: () {},
              ),
              Divider(),
              8.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${email}",
                    style: boldTextStyle(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ).flexible(),
                  Icon(Icons.arrow_forward_ios, size: 18),
                ],
              ).paddingSymmetric(horizontal: 16),
              16.height,
              Divider(height: 0),
              JSSettingComponent().expand(),
            ],
          ).expand(),
        ],
      ).paddingOnly(bottom: 16),
    );
  }
}
