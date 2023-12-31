import 'package:flutter/material.dart';
import 'package:job_search/utils/JSWidget.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:job_search/model/JSPopularCompanyModel.dart';
import 'package:job_search/screens/JSHomeScreen.dart';
import 'package:job_search/utils/JSColors.dart';
import 'package:job_search/utils/JSDataGenerator.dart';
import 'package:job_search/main.dart';

import '../screens/JSMessagesScreen.dart';
import '../screens/candidate.dart';
import '../screens/compamy.dart';
import '../screens/post_job.dart';
import '../screens/select.dart';

class JSDrawerScreen extends StatefulWidget {
  const JSDrawerScreen({Key? key}) : super(key: key);

  @override
  _JSDrawerScreenState createState() => _JSDrawerScreenState();
}

class _JSDrawerScreenState extends State<JSDrawerScreen> {
  List<JSPopularCompanyModel> drawerList = getDrawerList1();
  List<JSPopularCompanyModel> drawerList2 = getDrawerList2();

  @override
  void initState() {
    super.initState();
    init();

  }

  void init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? role = prefs.getInt('role');    String? token = prefs.getString('token');
    if(role ==0 && token != ''){
      setState(() {
        drawerList = getDrawerList3();
        drawerList2 = getDrawerList4();
      });
    } else if(token == '') {
      setState(() {
        drawerList = getDrawerList5();
        drawerList2 = getDrawerList6();
      });
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width(),
      height: context.height(),
      color: context.scaffoldBackgroundColor,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              color: context.scaffoldBackgroundColor,
              padding: EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  24.height,
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      onPressed: () {
                        finish(context);
                      },
                      icon: Icon(Icons.close),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: drawerList.map((e) {
                      int index = drawerList.indexOf(e);
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(e.companyName!, style: boldTextStyle()).paddingAll(8),
                              Icon(Icons.arrow_forward_ios, size: 16),
                            ],
                          ),
                          Divider(color: gray.withOpacity(0.4)).visible(index < 2),
                        ],
                      ).onTap(() {
                        e.widget.launch(context);
                      });
                    }).toList(),
                  ).paddingAll(8),
                  Container(color: appStore.isDarkModeOn ? scaffoldDarkColor : js_backGroundColor, height: 10, width: context.width()),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: drawerList2.map((e) {
                      int drawerIndex = drawerList2.indexOf(e);
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(e.companyName.validate(), style: boldTextStyle()),
                                  4.height,
                                  e.selectSkill.validate() == true
                                      ? Row(
                                          children: [
                                            commonCachedNetworkImage(
                                              e.companyImage.validate(),
                                              width: 20,
                                              height: 15,
                                              fit: BoxFit.cover,
                                            ).visible(e.selectSkill.validate() == true),
                                            8.width,
                                            Text(e.totalReview.validate(), style: secondaryTextStyle()),
                                          ],
                                        )
                                      : SizedBox(),
                                ],
                              ),
                              Icon(Icons.arrow_forward_ios, size: 16),
                            ],
                          ).paddingSymmetric(horizontal: 8, vertical: 8),
                          Divider(color: gray.withOpacity(0.4)).visible(drawerIndex < 7),
                        ],
                      ).onTap(() async {

                        final SharedPreferences prefs = await SharedPreferences.getInstance();
                        int? role = prefs.getInt('role');
                        String? token = prefs.getString('token');
                        late int cut;
                        if(role == 0){cut = 3;} else {cut = 5;}
                        if(token == null || token == ''){cut = 2;}
                        if (drawerIndex == cut) {
                          //Sign the person out
                          await prefs.setString('token', '');
                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute( builder: (ctx) => SelectScreen()), (route) => false);
                        } else {
                          print(e.widget.validate());
                          e.widget.validate().launch(context);
                        }
                      });
                    }).toList(),
                  ).paddingAll(8),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
