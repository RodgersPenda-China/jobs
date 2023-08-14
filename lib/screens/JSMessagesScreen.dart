import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:job_search/screens/JSCompleteProfileOneScreen.dart';
import 'package:job_search/screens/JSEnableNotificationDialog.dart';
import 'package:job_search/utils/JSColors.dart';
import 'package:job_search/utils/JSImage.dart';
import 'package:job_search/utils/JSWidget.dart';
import 'package:job_search/main.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;
import '../components/JSDrawerScreen.dart';
import '../controller/home.dart';
import 'JSCompanyProfileScreens.dart';

class JSMessagesScreen extends StatefulWidget {
  const JSMessagesScreen({Key? key}) : super(key: key);

  @override
  _JSMessagesScreenState createState() => _JSMessagesScreenState();
}

class _JSMessagesScreenState extends State<JSMessagesScreen> {
  var toYearItems = ['Inbox', 'Archive', 'Spam'];
  TabController? controller;

  String toYearValue = 'Inbox';

  @override
  void initState() {
    super.initState();
    make_https();
  }
  var messages = {};

  make_https() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String url = '';
      url = "https://x.smartbuybuy.com/job/index.php?get_message=1&role=0&token=${token}";
    setState(() {
      loading = true;
    });
    print(url);
    final response = await http.get(Uri.parse(url));
    setState(() {
      loading = false;
      messages = json.decode(response.body);
    });
    print('object');
    // var jobs = ;
  }
  bool loading = false;

  void init() async {
    //
  }
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          key: scaffoldKey,
          drawer: JSDrawerScreen(),
          appBar: jsAppBar(context, backWidget: true, homeAction: true, message: false, notifications: false, bottomSheet: true, callBack: () {
            setState(() {});
            scaffoldKey.currentState!.openDrawer();
          }),
          body: GetBuilder<HomeController>(builder: (authController){
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                16.height,
                TabBar(
                  labelColor: appStore.isDarkModeOn ? white : black,
                  unselectedLabelColor: gray,
                  isScrollable: false,
                  indicatorColor: js_primaryColor,
                  tabs: [
                    //Tab(child: Text("CV", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                    Tab(child: Text("Applied Jobs", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                    Tab(child: Text("Received Invites", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                  ],
                  controller: controller,
                ),
                TabBarView(
                  children: [
                    loading? Center(child: CircularProgressIndicator(color: Colors.blue,),):
                    messages['applied'].length == 0?
                    Center(child: Text('No Data Found'),)
                        :
                    ListView.separated(
                      itemCount: messages['applied'].length,
                      padding: EdgeInsets.all(8),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      separatorBuilder: (BuildContext context, int index) => Divider(),
                      itemBuilder: (context, index) {
                        //JSPopularCompanyModel data = popularCompanyList[index];

                        return  Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: (){
                                JSCompanyProfileScreens(id: messages['applied'][index]['id'],employer: 0,).launch(context);
                                 },
                              child: Row(
                                children: [
                                  commonCachedNetworkImage(messages['applied'][index]['image'], height: 50, width: 50, fit: BoxFit.contain),
                                  16.width,
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(messages['applied'][index]['name'], style: boldTextStyle()),
                                      4.height,

                                      Row(
                                        children: [
                                          Container(
                                              width: 200,
                                              child:Text('Job: ${messages['applied'][index]['job']}', style: secondaryTextStyle(color: js_textColor.withOpacity(0.7)))

                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                              width: 200,
                                              child:Text('CV: ${messages['applied'][index]['cv']}', style: secondaryTextStyle(color: js_textColor.withOpacity(0.7)))

                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                            ,
                            6.height,
                            Row(
                              children: [
                                Icon(Icons.location_on,color: Colors.blue,),
                                8.width,
                                Text('${messages['applied'][index]['location']}', style: secondaryTextStyle(color: Colors.blue)),
                              ],
                            ),
                          ],
                        ).onTap(() {
                          // JSCompanyProfileScreens(popularCompanyList: data).launch(context);
                        });
                      },
                    ),
                    loading? Center(child: CircularProgressIndicator(color: Colors.blue,),):
                    messages['candidate'].length == 0?
                    Center(child: Text('No Data Found'),)
                        :
                    ListView.separated(
                      itemCount: messages['applied'].length,
                      padding: EdgeInsets.all(8),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      separatorBuilder: (BuildContext context, int index) => Divider(),
                      itemBuilder: (context, index) {
                        //JSPopularCompanyModel data = popularCompanyList[index];

                        return  Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: (){
                                JSCompanyProfileScreens(id: messages['candidate'][index]['id'],employer: 0,).launch(context);
                              },
                              child: Row(
                                children: [
                                  commonCachedNetworkImage(messages['candidate'][index]['image'], height: 50, width: 50, fit: BoxFit.contain),
                                  16.width,
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(messages['candidate'][index]['name'], style: boldTextStyle()),
                                      4.height,

                                      Row(
                                        children: [
                                          Container(
                                              width: 200,
                                              child:Text('${messages['candidate'][index]['long_name']}', style: secondaryTextStyle(color: js_textColor.withOpacity(0.7)))

                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                            ,
                            6.height,
                            Row(
                              children: [
                                Icon(Icons.location_on,color: Colors.blue,),
                                8.width,
                                Text('${messages['candidate'][index]['location']}', style: secondaryTextStyle(color: Colors.blue)),
                              ],
                            ),
                          ],
                        ).onTap(() {
                          // JSCompanyProfileScreens(popularCompanyList: data).launch(context);
                        });
                      },
                    ),
                  ],
                ).expand(),
              ],
            );
          })),
    );
  }
}
