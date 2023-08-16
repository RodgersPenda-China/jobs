import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:job_search/components/JSDrawerScreen.dart';
import 'package:job_search/components/JSSettingComponent.dart';
import 'package:job_search/main.dart';
import 'package:job_search/utils/JSWidget.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/info.dart';

class ResetPassword extends StatefulWidget {
  ResetPassword({Key? key}) : super(key: key);

  @override
  _JSSettingScreenState createState() => _JSSettingScreenState();
}

class _JSSettingScreenState extends State<ResetPassword> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  late String terms;
  bool loading = true;
  late ScrollController _controller;

  @override
  void initState() {
    super.initState();

    loading = false;
    init();
  }
  String email = 'Please Login';
  void init() async {

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
        body:
        SingleChildScrollView(
          child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              16.height,

              Padding(padding: EdgeInsets.only(left: 10,right: 10),
                  child:
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      16.height,
                      Center(child: Text('Please Contact Via Whatsapp', style: boldTextStyle(size: 18)).paddingOnly(left: 16)),

                      20.height,
                      AppButton(
                          onTap: (){
                            launchUrl(Uri.parse('https://wa.me/26076150340?text=Hello,%20I%20Want%20To%20Reset%20Password.%20Thanks')
                                ,mode: LaunchMode.externalApplication);
                          },
                          color: Colors.green,
                          child:Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Contact Visa Whatsapp", style: boldTextStyle(color: white)),
                              8.width,
                              // CircularProgressIndicator(color: Colors.white,),
                            ],
                          )
                      ),
                    ],
                  )),
            ],
          ).paddingOnly(bottom: 16),
        ));
  }
}
